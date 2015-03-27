// This function gets cookie with a given name
function getCookie(name) {
    var cookieValue = null;
    if (document.cookie && document.cookie != '') {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = jQuery.trim(cookies[i]);
            // Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) == (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}


var csrftoken = null;
var current_graph = null;
var generated_paths = [];
var path_list_regex = /path-list-(\d+)/;
var editor_window = null;
var selected_node = null;
var current_modelname = null;
var current_username = null;
var current_edge = null;


/*
The functions below will create a header with csrftoken
*/

function csrfSafeMethod(method) {
    // these HTTP methods do not require CSRF protection
    return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
}

function sameOrigin(url) {
    // test that a given url is a same-origin URL
    // url could be relative or scheme relative or absolute
    var host = document.location.host; // host + port
    var protocol = document.location.protocol;
    var sr_origin = '//' + host;
    var origin = protocol + sr_origin;
    // Allow absolute or scheme relative URLs to same origin
    return (url == origin || url.slice(0, origin.length + 1) == origin + '/') ||
        (url == sr_origin || url.slice(0, sr_origin.length + 1) == sr_origin + '/') ||
        // or any other URL that isn't scheme relative or absolute i.e relative.
        !(/^(\/\/|http:|https:).*/.test(url));
}

$.ajaxSetup({
    beforeSend: function(xhr, settings) {
        if (!csrfSafeMethod(settings.type) && sameOrigin(settings.url)) {
            // Send the token to same-origin, relative URLs only.
            // Send the token only if the method warrants CSRF protection
            // Using the CSRFToken value acquired earlier
            xhr.setRequestHeader("X-CSRFToken", csrftoken);
        }
    }
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
    graph_name = "";

    $("#graph-list-display").children().each(function(i) {
        if ($(this).hasClass("active")) {
            graph_name = $(this).text();
        }
    });

    if (graph_name) {
        load_graph(graph_name);
    }
});


$('#start-game-btn').click(function(evt) {
    start_game();
});


$('#path-list li a').on('click', function(e) {
    e.preventDefault();
    var num = $(this).html();
    console.log(num);
    editor_window.highlighted_links = generated_paths[num];
    editor_window.restart();
});


function highlight_link(link_to_highlight) {
    editor_window.highlighted_links = generated_paths[link_to_highlight];
    editor_window.restart();
}


function start_game() {
    $.ajax({
        url : '/graph/generate_paths/',
        type : "GET",
        data : {
            // 'graph': current_graph,
            'graph': 'test',
            'source': 5,
            'destination': 1
        },

        success : function(json) {
            paths = json.paths;
            generated_paths = paths;
            $("#path-display-list").html(json.html);
            $("a[id*='path-list']").on('click', function(e) {
                e.preventDefault();
                var match = path_list_regex.exec(this.id);
                var num = match[1];
                editor_window.highlighted_links = generated_paths[num];
                editor_window.restart();
            });

            $("#path-display").show();
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


function load_graph(name) {
    $.ajax({
        url : '/graph/load_graph/',
        type : "GET",
        data : {
            'name': name
        },

        success : function(json) {
            // console.log(json);
            graph_ui = JSON.parse(json['graph_ui']);
            console.log(graph_ui);


            for (i = 0; i < graph_ui.nodes.length; ++i) {
                graph_ui.nodes[i].weight = 1.0;
            }

            for (i = 0; i < graph_ui.links.length; ++i) {
                graph_ui.links[i].source.weight = 0;
                graph_ui.links[i].target.weight = 0;

                source_index = graph_ui.links[i].source.index;
                target_index = graph_ui.links[i].target.index;

                graph_ui.links[i].source = graph_ui.nodes[source_index];
                graph_ui.links[i].target = graph_ui.nodes[target_index];
            }

            editor_window.nodes = graph_ui.nodes;
            editor_window.links = graph_ui.links;
            editor_window.force = d3.layout.force()
                .nodes(graph_ui.nodes)
                .links(graph_ui.links)
                .size([editor_window.width, editor_window.height])
                .linkDistance(150)
                .charge(-500)
                .on('tick', editor_window.tick);


            editor_window.lastNodeId = json['last_node_id'];
            editor_window.restart();
            editor_window.force.start();

            current_graph = name;
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


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


function save_graph(nodes, links, name) {
    $.ajax({
        url : '/graph/create_graph/',
        type : "POST", // http method
        dataType: "json",
        contentType: 'application/json', // JSON encoding
        data : JSON.stringify({
            'nodes' : nodes,
            'links' : links,
            'graph' : name
        }),
        // data : { the_post : $('#post-text').val() }, // data sent with the post request

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log("success"); // another sanity check
            current_graph = name;
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
};


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


$("#graph-editor").ready(function() {
    csrftoken = getCookie('csrftoken');
    editor_window = document.getElementById('graph-editor').contentWindow;
});


$("#add-model").click(function(e) {
    e.preventDefault();
    model_name = $("#model-name")[0].value;

    $.ajax({
        url : '/graph/add_model/',
        type : "POST", // http method
        dataType: "json",
        contentType: 'application/json', // JSON encoding

        data : JSON.stringify({
            'model_name' : model_name
        }),

        // handle a successful response
        success : function(json) {
            // $('#post-text').val(''); // remove the value from the input
            // console.log(json); // log the returned json to the console
            console.log(json); // another sanity check

            html = "<a href='#' class='list-group-item'>" + model_name  + "</a>";

            $("#model-display-list").append(html);

            $('#model-display-list a').click(function(e) {
                e.preventDefault();
                listActivate($(this), e);
                $("#user-operation-pane").removeClass('hidden');
                get_model_info($.trim(this.text));
            });
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
