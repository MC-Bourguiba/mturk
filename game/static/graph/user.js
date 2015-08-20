var graph_window = document.getElementById("graph-editor");
var generated_paths = [];
var path_ids = [];
var current_iteration = 0;
// var duration = 30;
var previous_allocation = [];
var editor_window = null;
var duration = -1;
var inter = null;
var previous_costs_dict = {};
var previous_flows_dict = {};

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

    // console.log(paths);
    // console.log(allocation);

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

            // console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


graph_window.onload = function() {
    // console.log($("#graph-hidden")[0].value);
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

    get_paths(username, current_iteration);
    update_previous_cost(username, current_iteration);
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
                // editor_window.restart();
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
                // update_paths(username, json['iteration']);
                update_previous_cost(username, json['iteration']);
                $("#completed-turn").toggle(false);
                // startTimer(duration, display);
            } else {
                if (json['completed_task']) {
                    $("#path-btns").toggle(false);
                    $("#completed-turn").toggle(true);
                }
            }

            current_iteration = json['iteration'];
            // console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


function get_paths(username, iteration) {
    // editor_window = document.getElementById("graph-editor").contentWindow;
    // editor_window.edit = false;

    $.ajax({
        url : "/graph/get_paths/" + username + "/",
        type : "GET",
        data : {"iteration": iteration},

        success : function(json) {
            // console.log(json);
            generated_paths = json['paths'];
            // console.log(generated_paths);
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


function update_previous_cost(username, iteration) {
    iteration = parseInt(iteration);

    $.ajax({
        url : "/graph/get_previous_cost/" + username + "/",
        type : "GET",
        data : {"iteration": iteration},

        success : function(json) {
            console.log(json);

            var cumulative_cost = {};
            var previous_cost = {};
            var previous_flow = {};

            // previous_costs_dict[iter_key] = {};

            k1 = Object.keys(json['previous_costs'])[0];

            for (var key in json['previous_costs']) {
                for (i = 0; i < json['previous_costs'][key].length; i += 1) {
                    if (!((iteration+i) in previous_costs_dict)) {
                        previous_costs_dict[iteration+i] = {};
                    }
                    previous_costs_dict[iteration+i][key] = json['previous_costs'][key][i];
                }
            }

            for (var key in json['previous_costs']) {
                cumulative_cost[key] = [];
                previous_cost[key] = [];
                // previous_flows[key] = [];
                var cost = 0;

                for (var iter in previous_costs_dict) {
                    val = previous_costs_dict[iter][key];
                    if (val == undefined) {
                        continue;
                    }

                    val = parseFloat(val);
                    cost += val;
                    cumulative_cost[key].push(cost);
                    previous_cost[key].push(val);
                }
                // previous_flows[key] = json['previous_flows'][key];
            }

            console.log('previous cost:');
            console.log(previous_cost);

            var chart = c3.generate({
                size: {
                    height: 250,
                },
                data: {
                    json : previous_cost
                    // json : json['previous_costs']
                },
                axis: {
                    y: {
                        tick: {
                            format: d3.format(".3f")
                        }
                    },
                    // x: {
                    //     tick: {
                    //         format: d3.format(".3f")
                    //     }
                    // }
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

                axis: {
                    y: {
                        tick: {
                            format: d3.format(".3f")
                        }
                    },
                },

                bindto: '#cumulative_chart'
            });

            // var flows_chart = c3.generate({
            //     size: {
            //         height: 250,
            //     },
            //     data: {
            //         json : previous_flow
            //         // json : json['previous_flows']
            //     },
            //     axis: {
            //         y: {
            //             tick: {
            //                 format: d3.format(".3f")
            //             }
            //         },
            //     },

            //     bindto: '#flows_chart'
            // });
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
