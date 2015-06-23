var graph_window = document.getElementById("graph-editor");
var generated_paths = [];
var path_ids = [];
var current_iteration = -1;
// var duration = 30;
var previous_allocation = [];
var editor_window = null;
var duration = -1;
var inter = null;

// var has_displayed_paths = false;


function on_node_selected(selected_node) {

}


function on_edge_selected(selected_edge) {

}


// $("#submit-game-btn").click(function(e) {
//     e.preventDefault();
//     submit_distribution();
// });


$("#show-edge-btn").click(function(e) {
    e.preventDefault();
    if (editor_window == null) {
        editor_window = document.getElementById("graph-editor").contentWindow;
    }
    editor_window.show_edge_cost = true;
    editor_window.restart();
});


$("#clear-edge-btn").click(function(e) {
    e.preventDefault();
    if (editor_window == null) {
        editor_window = document.getElementById("graph-editor").contentWindow;
    }
    editor_window.show_edge_cost = false;
    editor_window.show_highlighted_paths = false;
    editor_window.restart();
});


// temporary: true if user does not want to finish turn
function submit_distribution(update_state) {

    var paths = [];
    var allocation = [];

    $("#path-list tr").each(function(idx, li) {
        paths.push(parseInt($(li).find("a").attr('id')));
        allocation.push(parseFloat($(li).find("input")[0].value/100));
    });

    console.log(paths);
    console.log(allocation);

    $.ajax({
        url : "/graph/submit_distribution/",
        type : "POST",
        data : JSON.stringify({
            "username" : $("#username-hidden")[0].value,
            "allocation" : allocation,
            "ids" : paths,
        }),

        success : function(json) {

            if (update_state) {
                update_from_state($("#username-hidden")[0].value);
            }

            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


graph_window.onload = function() {
    console.log($("#graph-hidden")[0].value);
    load_graph($("#graph-hidden")[0].value);
};


function update_loop() {
    update_from_state($("#username-hidden")[0].value);

    // TODO: Use duration to do the timer in client-side.

    // if (duration == -1) {
    //     setTimeout(update_loop, 5); // Update every 5 seconds
    // } else {
    //     display = $('#time_countdown');
    //     setTimeout(update_loop, 1000 * duration); // or duration seconds
    //     if (inter != null) {
    //         clearInterval(inter);
    //     }
    //     startTimer(duration, display);
    // }
}


function post_temporary_distribution_loop() {
    setTimeout(post_temporary_distribution_loop, 1000); // Update every second.
    submit_distribution(true);
}


$(document).ready(function() {
    username = $("#username-hidden")[0].value;

    if (editor_window == null) {
        editor_window = document.getElementById("graph-editor").contentWindow;
    }

    update_paths(username);
    update_previous_cost(username);
    update_loop();
    setTimeout(post_temporary_distribution_loop, 5000); // Some timing bug here! Should not have to wait 5s to post distribution!
    display = $('#time_countdown');
    // startTimer(duration, display);
});


function update_from_state(username) {
    $.ajax({
        url : "/graph/current_state/",
        type : "GET",

        success : function(json) {

            display = $('#time_countdown');

            duration = json['duration'];

            if (editor_window != null) {
                editor_window = document.getElementById("graph-editor").contentWindow;
            }

            if (json.hasOwnProperty('edge_max_flow')) {
                editor_window.edge_max_flow = json['edge_max_flow'];
            }

            if (json.hasOwnProperty('secs')) {
                if (json['secs'] >= 0) {
                    display.text(json['secs']);

                    if (inter != null) {
                        clearInterval(inter);
                    }

                    startTimer(json['secs'], display);
                } else {
                    display.text('0');
                }
            } else {
                display.text('');
            }

            if (json.hasOwnProperty('edge_cost')) {
                // console.info("Setting edge_cost!!!");
                editor_window.edge_cost = json['edge_cost'];
                editor_window.restart();
                // console.info(edge_cost);
            }


            // TODO: Fix this so that the previous allocation "sticks"
            // if (previous_allocation.length > 0) {
            //     $("#path-list tr").each(function(idx, li) {
            //         path_id = parseInt($(li).find("a").attr('id'));
            //         index = path_ids.indexOf(path_id);
            //         allocation = previous_allocation[index];
            //         $('#slider').slider('setValue', allocation);

            //         // paths.push(parseInt($(li).find("a").attr('id')));
            //         // allocation.push(parseFloat($(li).find("input")[0].value/100));
            //     });
            // }

            if (current_iteration != json['iteration']) {
                $("#path-btns").toggle(true);
                update_paths(username);
                update_previous_cost(username);
                $("#completed-turn").toggle(false);
                // startTimer(duration, display);
            } else {
                if (json['completed_task']) {
                    $("#path-btns").toggle(false);
                    $("#completed-turn").toggle(true);
                }
            }

            // if (json['completed_task']) {
            //     if (current_iteration != json['iteration']) {
            //         $("#path-btns").toggle(true);
            //         update_paths(username);
            //         update_previous_cost(username);
            //     } else {
            //         $("#path-btns").toggle(false);
            //         $("#completed-turn").toggle(true);
            //     }
            // }

            current_iteration = json['iteration']

            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


function update_paths(username) {
    // editor_window = document.getElementById("graph-editor").contentWindow;
    // editor_window.edit = false;

    $.ajax({
        url : "/graph/get_paths/" + username + "/",
        type : "GET",

        success : function(json) {
            console.log(json);
            generated_paths = json['paths'];
            console.log(generated_paths);
            path_ids = json['path_ids'];

            // if (!has_displayed_paths) {
            $("#path-display-list").html(json['html']);
            has_displayed_paths = true;
            // }

            if (editor_window == null) {
                editor_window = document.getElementById("graph-editor").contentWindow;
            }
            editor_window.edit = false;

            $('#path-list tr  a').click(function(e) {
                e.preventDefault();
                // This is soooooooo bad
                var num = parseInt($(this).html().substr('Path '.length));
                console.log(num);

                if (editor_window == null) {
                    editor_window = document.getElementById("graph-editor").contentWindow;
                }
                editor_window.edit = false;
                editor_window.show_highlighted_paths = true;
                editor_window.highlighted_links = generated_paths[num];
                // console.log(generated_paths[num]);
                editor_window.restart();
            });
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


function update_previous_cost(username) {
    $.ajax({
        url : "/graph/get_previous_cost/" + username + "/",
        type : "GET",

        success : function(json) {
            console.log(json);

            var cumulative_cost = {};

            for (var key in json['previous_costs']) {
                var path = json['previous_costs'][key];
                cumulative_cost[key] = [];
                var cost = 0;
                for (i=0; i < path.length; i += 1) {
                    cost += path[i];
                    cumulative_cost[key].push(cost);
                }
            }

            console.log('cumulative cost:');
            console.log(cumulative_cost);

            var chart = c3.generate({
                size: {
                    height: 250,
                },
                data: {
                    json : json['previous_costs']
                },
                bindto: '#chart'
            });

            var cumulative_chart = c3.generate({
                size: {
                    height: 250,
                },
                data: {
                    json : cumulative_cost
                },

                bindto: '#cumulative_chart'
            });

            var flows_chart = c3.generate({
                size: {
                    height: 250,
                },
                data: {
                    json : json['previous_flows']
                },

                bindto: '#flows_chart'
            });
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


function startTimer(duration, display) {
    var timer = duration, minutes, seconds;
    inter = setInterval(function () {
        minutes = parseInt(timer / 60, 10)
        seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        display.text(seconds);

        if (--timer < 0) {
            timer = duration;
            clearInterval(inter);
            submit_distribution(true);
            inter = null;
        }
    }, 1000);
}
