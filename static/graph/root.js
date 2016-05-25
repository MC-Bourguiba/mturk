var graph_name = "";
var user_predictions = false;
var current_game =""

function merge_options(obj1,obj2){
    var obj3 = {};
    for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
    for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
    return obj3;
}


$('#turn-on-edge').click(function(evt) {
    $.ajax({
        url : "/graph/start_edge_highlight/",
        type : "GET",

        success : function(json) {
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});



$('#turn-off-edge').click(function(evt) {
    $.ajax({
        url : "/graph/stop_edge_highlight/",
        type : "GET",

        success : function(json) {
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


$('#clear-path').click(function(evt) {
    $.ajax({
        url : "/graph/clear_path_cache/",
        type : "GET",

        success : function(json) {
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});



$('#save-data-btn').click(function(evt) {
    $.ajax({
        url : "/graph/save_data/",
        type : "GET",

        success : function(json) {
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


$('#save-graph-btn').click(function(evt) {
    nodes = document.getElementById('graph-editor').contentWindow.nodes;
    links = document.getElementById('graph-editor').contentWindow.links;
    var name=prompt("Enter graph name");

    if (name) {
        save_graph(nodes, links, name);
    }
});


$('#load-graph-btn').click(function(evt) {
    evt.preventDefault();

    $("#graph-list-display").children().each(function(i) {
        if ($(this).hasClass("active")) {
            graph_name = $(this).text();
        }
    });

    if (graph_name) {
        load_graph(graph_name);
        update_user_cost(graph_name);
        current_graph = graph_name;
    }
});

$('#load-game-btn').click(function(evt) {
    evt.preventDefault();

    $("#game-list-display").children().each(function(i) {
        if ($(this).hasClass("active")) {
            g_name = $(this).text();
        }
    });

    if (g_name) {
        current_game = g_name;
    }
});



$('#show-predictions-btn').click(function(evt) {
    evt.preventDefault();
    user_predictions = true;

    get_user_predictions();

    // $("#graph-list-display").children().each(function(i) {
    //     if ($(this).hasClass("active")) {
    //         graph_name = $(this).text();
    //     }
    // });
});


$('#add-game-btn').click(function(evt) {
    evt.preventDefault();

    var game_name = $("#game-input")[0].value;

    //if (game_name != '') {
      //  window.location.href = "/graph/accounts/profile?game=" + game_name;
    //}
    if (game_name != '') {
     $.ajax({
        url : '/graph/add_game/',
        type : "POST", // http method
        dataType: "json",
        contentType: 'application/json', // JSON encoding

        data : JSON.stringify({
            'game_name' : game_name,
        }),

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log(json); // another sanity check
            if(json['success']){
            window.location.reload();


            }

        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });

    }
});


$('#go-game-btn').click(function(evt) {
    evt.preventDefault();

    var game_name = '';

    $("#game-list-display").children().each(function(i) {
        if ($(this).hasClass("active")) {
            game_name = $(this).text();
        }
    });

    if (game_name != '') {
        window.location.href = "/graph/accounts/profile?game=" + game_name;
    }
});


function get_user_predictions() {
    if (user_predictions && graph_name && current_username) {
        $.ajax({
            url : "/graph/get_user_predictions/" + current_username + "/",
            type : "GET",

            success : function(json) {
                console.log(json);

                regions = {};

                for (var key in json['actual']) {
                    if (json['actual'].hasOwnProperty(key)) {
                        regions[key] = [{'start': 2, 'end': 100, 'style':'dashed'}];
                    }
                }

                console.log(regions);

                var chart = c3.generate({
                    data: {
                        x: 'x',
                        json : merge_options(json['predictions'], json['actual'])
                    },

                    axis: {
                        y: {
                            tick: {
                                format: d3.format(".3f")
                            }
                        },
                    },

                    region: regions,

                    // region: {
                    //     'actual_1': [{'start':2, 'end': 100, 'style': 'dashed'}]
                    // },

                    // region: {
                    //     'actual_1':
                    // },

                    bindto: '#predictions_chart'
                });
            },

            // handle a non-successful response
            error : function(xhr,errmsg,err) {
                console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
            }
        });
        // update_user_predictions(graph_name, current_username);
    }
}


$('#slider-game-mode-input').click(function() {
    var set_single_slider = false;
    if($("#slider-game-mode-input").prop("checked")){
        set_single_slider = true;
        // console.log("single slider checked!!!");
        // } else {
        //     set_single_slider = false;
        //     // console.log("single slider unchecked!!!");
    }

    $.ajax({
        url : "/graph/set_game_mode/",
        type : "POST",

        data : JSON.stringify({
            'single_slider' : set_single_slider,
            'game' : get_game_name()
        }),

        success : function(json) {
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


function update_user_cost(graph_name) {
    get_user_predictions();

    $.ajax({
        url : "/graph/get_user_costs/" + graph_name + "/",
        type : "GET",

        success : function(json) {
            console.log(json);

            if (json['started']) {
                var chart = c3.generate({
                    data: {
                        json : json['current_costs']
                    },

                    axis: {
                        y: {
                            tick: {
                                format: d3.format(".3f")
                            }
                        },
                    },

                    bindto: '#chart'
                });

                var chart = c3.generate({
                    data: {
                        x: 'x',
                        json : json['user_etas']
                    },

                    axis: {
                        y: {
                            tick: {
                                format: d3.format(".3f")
                            }
                        },
                    },

                    bindto: '#learning_chart'
                });
            }
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}

function update_ui() {
    dr = get_duration();
    setTimeout(update_ui, dr*1000); // Update every 10 seconds
    if (graph_name) {
        update_user_cost(graph_name);
    }
}


$(document).ready(function() {

    update_ui()
    check_connection_loss();
    if (graph_name) {
        update_user_cost(graph_name);
    }
});


$('#model-display-list a').click(function(e) {
    e.preventDefault();
    get_model_info($.trim(this.text));
});


function get_model_info(modelname) {
    $.ajax({
        url : '/graph/model/' + modelname + '/',
        type : "GET", // http method
        // data : { the_post : $('#post-text').val() }, // data sent with the post request

        // handle a successful response
        success : function(json) {
            $("#model-info-pane").html(json['html']);
            // console.log(json); // log the returned json to the console
            console.log(json);
            console.log("success"); // another sanity check

            current_modelname = modelname;
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


function get_game_name() {
    return document.getElementsByClassName("currently_in_use")[0].innerHTML;
}


function save_graph(nodes, links, name) {


    $.ajax({
        url : '/graph/create_graph/',
        type : "POST", // http method
        dataType: "json",
        contentType: 'application/json', // JSON encoding
        data : JSON.stringify({
            'nodes' : nodes,
            'links' : links,
            'graph' : name,
            'game' : get_game_name()
        }),
        // data : { the_post : $('#post-text').val() }, // data sent with the post request

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log("success"); // another sanity check
            current_graph = name;
            location.reload();

        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
};


$("#assign-game").click(function(e) {
    e.preventDefault();

    var game_name = '';
    var username = '';

    $("#game-list-display").children().each(function(i) {
        if ($(this).hasClass("active")) {
            game_name = $(this).text();
        }
    });

    $("#user-list-display").children().each(function(i) {
        if ($(this).hasClass("active")) {
            username = $(this).text();
        }
    });


    $.ajax({
        url : '/graph/assign_game/',
        type : "POST", // http method
        dataType: "json",
        contentType: 'application/json', // JSON encoding

        data : JSON.stringify({
            'username' : username,
            'game' : game_name,
        }),

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log(json); // another sanity check
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


$("#assign-start-node").click(function(e) {
    e.preventDefault();
    assign_model_node(current_modelname, current_graph, selected_node.id, true);
});

$("#assign-destination-node").click(function(e) {
    e.preventDefault();
    assign_model_node(current_modelname, current_graph, selected_node.id, false);
});

$("#assign-graph").click(function(e) {
    e.preventDefault();
    assign_model_graph(current_modelname, current_graph);
});

$("#assign-graph-to-game").click(function(e) {
    e.preventDefault();
    assign_game_graph(current_game, current_graph);
});

$("#start-game").click(function(e) {
    e.preventDefault();
    $.ajax({
        url : '/graph/start_game/',
        type : "GET", // http method
        //dataType: "json",
        //contentType: 'application/json', // JSON encoding

       // data : JSON.stringify({
         //   'graph' : current_graph,
           // 'game' : get_game_name()
        //}),

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log(json); // another sanity check

            // $("#model-info-graph").text(json['graph_name']);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


$("#stop-game").click(function(e) {
    e.preventDefault();
    $.ajax({
        url : '/graph/stop_game/',
        type : "POST", // http method
        dataType: "json",
        contentType: 'application/json', // JSON encoding

        data : JSON.stringify({
            'graph' : current_graph,
            'game' : get_game_name()
        }),

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log(json); // another sanity check
            if(json['success']){
            $('#set-countdown').click();

            }

            // $("#model-info-graph").text(json['graph_name']);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


function assign_model_graph(modelname, graph_name) {
    $.ajax({
        url : '/graph/assign_model_graph/',
        type : "POST", // http method
        dataType: "json",
        contentType: 'application/json', // JSON encoding

        data : JSON.stringify({
            'model_name' : modelname,
            'graph_name' : graph_name,
        }),

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log(json); // another sanity check

            $("#model-info-graph").text(json['graph_name']);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}

function assign_game_graph(gamename, graph_name) {
    $.ajax({
        url : '/graph/assign_game_graph/',
        type : "POST", // http method
        dataType: "json",
        contentType: 'application/json', // JSON encoding

        data : JSON.stringify({
            'game_name' : gamename,
            'graph_name' : graph_name,
        }),

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log(json); // another sanity check
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}

function assign_model_node(modelname, graph_name, node_id, is_start) {
    $.ajax({
        url : '/graph/assign_model_node/',
        type : "POST", // http method
        dataType: "json",
        contentType: 'application/json', // JSON encoding

        data : JSON.stringify({
            'model_name' : modelname,
            'graph_name' : graph_name,
            'node_ui_id': node_id,
            'is_start': is_start
        }),

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log(json); // another sanity check

            if (is_start) {
                $("#model-info-start").text(json['node_ui_id']);
            } else {
                $("#model-info-destination").text(json['node_ui_id']);
            }
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


function on_node_selected(node) {
    // console.log(node);
    selected_node = node;
    $("#selected-node").text(node.id);
};

function on_edge_selected(edge) {
    console.log(edge);
    update_edge_info(edge.id);
}

function update_edge_info(edge_id) {
    if (current_graph != null) {
        $.ajax({
            url : '/graph/get_edge_cost/' + edge_id + '/',
            type : "GET", // http method
            // data : { the_post : $('#post-text').val() }, // data sent with the post request

            // handle a successful response
            success : function(json) {
                console.log(json);
                console.log("success"); // another sanity check

                current_edge = edge_id;
                $("#edge-cost-function").text(json['cost']);
                $("#selected-edge").text(json['from_node'] + " -> " + json['to_node']);
            },

            // handle a non-successful response
            error : function(xhr,errmsg,err) {
                console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
            }
        });
    }
}


$("#add-model").click(function(e) {
    e.preventDefault();
    model_name = $("#model-name")[0].value;

    $.ajax({
        url : '/graph/add_model/',
        type : "POST", // http method
        dataType: "json",
        contentType: 'application/json', // JSON encoding

        data : JSON.stringify({
            'model_name' : model_name,
            'graph_name': graph_name
        }),

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log(json); // another sanity check

            if (json['success']) {
                html = "<a href='#' class='list-group-item'>" + model_name  + "</a>";

                $("#model-display-list").append(html);

                $('#model-display-list a').click(function(e) {
                    e.preventDefault();
                    listActivate($(this), e);
                    $("#user-operation-pane").removeClass('hidden');
                    get_model_info($.trim(this.text));
                });
            }
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


$('#user-list-display a').click(function(e) {
    e.preventDefault();
    get_user_model_info($.trim(this.text));
});


function get_user_model_info(username) {
    $.ajax({
        url : '/graph/user_model_info/' + username + '/',
        type : "GET", // http method
        // data : { the_post : $('#post-text').val() }, // data sent with the post request

        // handle a successful response
        success : function(json) {
            $("#user-model-info-pane").html(json['html']);
            // console.log(json); // log the returned json to the console
            console.log(json);
            console.log("success"); // another sanity check

            current_username = username;
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


$("#assign-user-model").click(function(e) {
    e.preventDefault();

    $.ajax({
        url : '/graph/assign_user_model/',
        type : "POST", // http method

        data : JSON.stringify({
            'username' : current_username,
            'modelname' : current_modelname
        }),

        // handle a successful response
        success : function(json) {
            // console.log(json); // log the returned json to the console
            console.log(json);
            get_user_model_info(current_username)
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});

$("#generate-pm").click(function(e) {
    e.preventDefault();

    $.ajax({
        url : '/graph/generate-pm/',
        type : "POST", // http method

        data : JSON.stringify({
           'graph' : current_graph,
        }),

        // handle a successful response
        success : function(json) {
            // console.log(json); // log the returned json to the console
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});
$("#assign-pm-to-p").click(function(e) {
    e.preventDefault();

    $.ajax({
        url : '/graph/assign_pm_to_player/',
        type : "GET", // http method


        // handle a successful response
        success : function(json) {
            // console.log(json); // log the returned json to the console
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


$("#assign-cost-btn").click(function(e) {
    e.preventDefault();
    var cost = $("#cost-input")[0].value;
    console.log("cost: " + cost);

    $.ajax({
        url : '/graph/assign_edge_cost/',
        type : "POST", // http method

        data : JSON.stringify({
            'edge_id' : current_edge,
            'cost': cost
        }),

        // handle a successful response
        success : function(json) {
            // console.log(json); // log the returned json to the console
            console.log(json);
            update_edge_info(current_edge);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


$("#assign-all-cost-btn").click(function(e) {
    e.preventDefault();
    var cost = $("#cost-input")[0].value;
    console.log("cost: " + cost);

    $.ajax({
        url : '/graph/assign_all_edge_cost/',
        type : "POST", // http method

        data : JSON.stringify({
            'graph' : current_graph,
            'cost': cost
        }),

        // handle a successful response
        success : function(json) {
            // console.log(json); // log the returned json to the console
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


$("#assign-flow-btn").click(function(e) {
    e.preventDefault();
    var flow = $("#flow-input")[0].value;
    console.log("flow" + flow);

    $.ajax({
        url : '/graph/assign_model_flow/',
        type : "POST", // http method

        data : JSON.stringify({
            'modelname' : current_modelname,
            'flow': flow
        }),

        // handle a successful response
        success : function(json) {
            // console.log(json); // log the returned json to the console
            console.log(json);
            get_model_info(current_modelname)
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


$("#assign-duration-btn").click(function(e) {
    e.preventDefault();
    var duration = parseInt($("#duration-input")[0].value);
    console.log("duration: " + duration);
    $.ajax({
        url : '/graph/assign_duration/',
        type : "POST",

        data : JSON.stringify({
            'duration' : duration,
            'game' : get_game_name()
        }),

        // handle a successful response
        success : function(json) {
            // console.log(json); // log the returned json to the console
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


$("#get-graph-game").click(function(e) {
    e.preventDefault();

    $.ajax({
        url : '/graph/get_game_graph/',
        type : "POST",

        data : JSON.stringify({

            'game' : current_game
        }),

        // handle a successful response
        success : function(json) {
            // console.log(json); // log the returned json to the console
            document.getElementById("graph-game").innerHTML=json['graph'];
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});

function start_countdown(){
   $.ajax({
        url : "/graph/waiting_countdown/",
        type : "GET",

        success : function(json) {
            console.log(json);
            document.getElementById("wait").innerHTML=json['ping'];
            if(json['ping']<0){
            $("#start-game").click();
            setTimeout(window.location.reload(),1000);

            }
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


$('#start-countdown').click(function(evt) {
    setInterval(start_countdown ,1000);
});

$('#stop-countdown').click(function(evt) {
    window.location.reload();
});


$('#set-countdown').click(function(evt) {
     $.ajax({
        url : "/graph/set_waiting_time/",
        type : "GET",

        success : function(json) {
            console.log(json);
            document.getElementById("wait").innerHTML=json['countdown'];

        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


function get_duration() {
    return $("#duration-hidden")[0].value;
}


function check_connection_loss() {
    current_duration = get_duration();
    setTimeout(check_connection_loss, (current_duration)*1000);
    check_connection();


}

function check_connection(){
    $.ajax({
        url : "/graph/check_connection/",
        type : "GET",


        success : function(json) {
            console.log(json);
            console.log(json['graph']);

        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });

}