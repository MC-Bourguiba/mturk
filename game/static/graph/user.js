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

function get_game_name() {
    return $("#game_name")[0].value;
}

function get_username() {
    return $("#username-hidden")[0].value;
}


$.fn.exists = function () {
    return this.length !== 0;
}


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


function get_flow_allocation() {
    var paths = [];
    var allocation = [];
    var epsilon = 0.00000001;

    $("#path-list tr").each(function(idx, li) {
        paths.push(parseInt($(li).find("a").attr('id')));
        allocation.push(parseFloat($(li).find("input")[0].value/100));
    });

    var explore_index = 0.5;

    if ($("#game-mode").prop("value") == "single_slider_mode") {
        allocation = [];
        if ($("#ex").exists()) {
            explore_index = parseInt($("#ex")[0].value)/100;
        }

        var normalization = 1.0;
        var last_iter = 1;

        if (Object.keys(previous_costs_dict).length > 0) {
            last_iter = Math.max.apply(Math, Object.keys(previous_costs_dict));

            normalization = 0.0;

            for (var k in Object.keys(previous_costs_dict[last_iter])) {
                var previous_cost = previous_costs_dict[last_iter][k];
                var previous_flow = previous_flows_dict[last_iter][k];
                normalization += (previous_flow+epsilon)*Math.exp(-explore_index*previous_cost);
            }
        }

        for (var p in paths) {
            if (Object.keys(previous_costs_dict).length == 0) {
                //console.log("IN HERE");
                average_distr = 1.0/paths.length;

                for (i=0; i < paths.length; i += 1) {
                    allocation.push(average_distr);
                }

                break;
            } else {
                var previous_cost = previous_costs_dict[last_iter][p];
                var previous_flow = previous_flows_dict[last_iter][p];
                var alloc = (previous_flow+epsilon)*Math.exp(-explore_index*previous_cost)/normalization;
                allocation.push(alloc);
            }
        }
    }

    //console.log(allocation);
    //console.log("explore_index: ");
   // console.log(explore_index);
    //console.log(normalization);

    return [paths, allocation];
}


// temporary: true if user does not want to finish turn
function submit_distribution(update_state) {

    var paths = [];
    var allocation = [];

    $("#path-list tr").each(function(idx, li) {
        paths.push(parseInt($(li).find("a").attr('id')));
        // allocation.push(parseFloat($(li).find("input")[0].value/100));
    });

    var ps = get_flow_allocation();

    var paths = ps[0];
    var allocation = ps[1];

    $.ajax({
        url : "/graph/submit_distribution/",
        type : "POST",
        data : JSON.stringify({
            "username" : get_username(),
            "allocation" : allocation,
            "ids" : paths,
        }),

        success : function(json) {

            if (update_state) {
                update_from_state(get_username());
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


function post_temporary_distribution_loop() {
    setTimeout(post_temporary_distribution_loop, 1000); // Update every second.
    submit_distribution(true);



}

function start_heartbeat_loop() {
    setTimeout(start_heartbeat_loop, 10000); // Update every second.

    heartbeat_loop();


}

function heartbeat_loop() {
    var ts = Date.now()/1000;
    var username = get_username();

    $.ajax({
        url : "/graph/heartbeat/",
        type : "POST",
        data : {"username": username,
                "timestamp": ts},

        success : function(json) {
            console.log(json);
            if(json['current_game_stopped']){
            window.location.reload();
            }
        }
    });
}


$(document).ready(function() {
    username = get_username();
    is_bot = $("#bot-hidden")[0].value;
    if (editor_window == null) {
        editor_window = document.getElementById("graph-editor").contentWindow;
    }

    get_paths(username, current_iteration);
    update_previous_cost(username, current_iteration);
    console.log($("#bot-hidden")[0].value);

    update_from_state(get_username());
    setTimeout(post_temporary_distribution_loop, 5000); // Some timing bug here! Should not have to wait 5s to post distribution!
    display = $('#time_countdown');
    // startTimer(duration, display);
   setTimeout(start_heartbeat_loop, 5000);
});


function update_from_state(username) {
    $.ajax({
        url : "/graph/current_state/",
        type : "POST",

        dataType: "json",
        contentType: 'application/json', // JSON encoding

        data : JSON.stringify({
            'game' : get_game_name()
        }),

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
                    /*if(json['secs'] == 6 && $("#bot-hidden")[0].value=='True'){
                       window.location.reload();
                    }*/
                    display.text(json['secs']);

                    if (inter != null) {
                        clearInterval(inter);
                    }

                    if (current_iteration != json['iteration']) {
                        startTimer(json['secs'], display);
                    }
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
            //console.log(current_iteration);
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

            $("#path-display-list").html(json['html']);
            has_displayed_paths = true;

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

            $("#ex").on("slideStop", function (ev) {
                update_slides();
            });


            // $("#ex").slider({
            //     change: function(event, ui) {
            //         console.log("AAAAAAAAA");
            //         var ps = get_flow_allocation();

            //         var paths = ps[0];
            //         var allocation = ps[1];

            //         // for (i=0; i < paths.length; i += 1) {
            //         //     var p = paths[i];
            //         //     var alloc = allocation[i];

            //         //     // $("ex" + String(p)).
            //         //     var slider_p = new Slider('#ex' + String(p), {
            //         //         tooltip: 'always',
            //         //         formatter: function(value) {
            //         //             weights[p] = alloc;
            //         //             return alloc;
            //         //             // return value/100;
            //         //         }
            //         //     });
            //         // }
            //     }
            // });
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


function update_slides() {
    var ps = get_flow_allocation();

    var paths = ps[0];
    var allocation = ps[1];

    var total_alloc = 0.0;

    for (i=0; i < allocation.length; i += 1) {
        var alloc = allocation[i];
        //console.log(alloc);
        total_alloc += parseFloat(alloc);
    }

   // console.log("allocation");
    //console.log(allocation);

    for (i=0; i < paths.length; i += 1) {
        var pa = paths[i];
        var alloc = allocation[i];
        var sl = slider_paths_dict[pa];
        sl.setValue((alloc/total_alloc)*100);
    }
}


function update_previous_cost(username, iteration) {
    iteration = parseInt(iteration);

    $.ajax({
        url : "/graph/get_previous_cost/" + username + "/",
        type : "GET",
        data : {"iteration": iteration},

        success : function(json) {
           // console.log(json);

            var cumulative_cost = {};
            var previous_cost = {};
            var previous_flow = {};

            // previous_costs_dict[iter_key] = {};

            //console.log(json);

            for (var key in json['previous_costs']) {
                for (i = 0; i < json['previous_costs'][key].length; i += 1) {
                    if (!((iteration+i) in previous_costs_dict)) {
                        previous_costs_dict[iteration+i] = {};
                    }
                    previous_costs_dict[iteration+i][key] = json['previous_costs'][key][i];
                }
            }

            for (var key in json['previous_flows']) {
                for (i = 0; i < json['previous_flows'][key].length; i += 1) {
                    if (!((iteration+i) in previous_flows_dict)) {
                        previous_flows_dict[iteration+i] = {};
                    }
                    previous_flows_dict[iteration+i][key] = json['previous_flows'][key][i];
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


            for (var key in json['previous_flows']) {
                previous_flow[key] = [];

                for (iter in previous_flows_dict) {
                    val = previous_flows_dict[iter][key];
                    if (val == undefined) {
                        continue;
                    }

                    val = parseFloat(val)*parseInt(json['number_pm']);
                    previous_flow[key].push(val);
                }
            }

            // console.log('previous cost:');
            // console.log(previous_cost);

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

            // var cumulative_chart = c3.generate({
            //     size: {
            //         height: 250,
            //     },
            //     data: {
            //         json : cumulative_cost
            //     },

            //     axis: {
            //         y: {
            //             tick: {
            //                 format: d3.format(".3f")
            //             }
            //         },
            //     },

            //     bindto: '#cumulative_chart'
            // });

            var flows_chart = c3.generate({
                size: {
                    height: 250,
                },
                data: {
                    json : previous_flow
                    // json : json['previous_flows']
                },
                axis: {
                    y: {
                        tick: {
                            format: d3.format(".3f")
                        }
                    },
                },

                bindto: '#flows_chart'
            });

            if ($("#game-mode").prop("value") == "single_slider_mode") {
                var index = Object.keys(previous_costs_dict).length-1;

                var val_total = 0.0;
                var cum_val_total = 0.0;

                for (var key in previous_cost) {
                    val_total += previous_cost[key][index];
                    cum_val_total += cumulative_cost[key][index];
                }

                $("#previous_cost_table").text(val_total.toFixed(3));
                $("#cumulative_cost_table").text(cum_val_total.toFixed(3));

            }

            for (var key in json['previous_costs']) {
                var index = Object.keys(previous_costs_dict).length-1;
                var val = previous_cost[key][index];
                var cum_val = cumulative_cost[key][index];
                $("#previous_cost_table_" + String(key)).text(val.toFixed(3));
                $("#cumulative_cost_table_" + String(key)).text(cum_val.toFixed(3));
            }

            for (var key in json['previous_flows']) {
                var index = Object.keys(previous_flows_dict).length-1;
                var val = previous_flow[key][index];
                $("#previous_flow_table_" + String(key)).text(val.toFixed(3));
            }

            update_slides();
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

        minutes = minutes < 10 ? minutes : minutes;
        seconds = seconds < 10 ? seconds : seconds;

        display.text(seconds);

        if (--timer < 0) {
            timer = duration;
            clearInterval(inter);
            submit_distribution(true);
            inter = null;
        }
    }, 1000);
}

