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
var csrftoken = getCookie('csrftoken');
var current_graph = null;
var generated_paths = [];
var path_list_regex = /path-list-(\d+)/;
var editor_window = document.getElementById('graph-editor').contentWindow;

$("#path-display").hide();

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
    name = 'first'; // TODO: Show user list of graph names in database.

    var name=prompt("Enter graph name");

    if (name) {
        load_graph(name);
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
        url : "/graph/generate_paths/",
        type : "GET",
        data : {
            'graph': current_graph,
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
        url : "/graph/load_graph/",
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


function save_graph(nodes, links, name) {
    $.ajax({
        url : "/graph/create_graph/", // the endpoint
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


editor_window.onload = function() {
     // load_graph("name");
};
