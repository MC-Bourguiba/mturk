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
var selected_node = null;
var current_modelname = null;
var current_username = null;
var current_edge = null;
var editor_window = document.getElementById("graph-editor").contentWindow;

csrftoken = getCookie('csrftoken');


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
            // console.log(graph_ui);

            editor_window = document.getElementById('graph-editor').contentWindow;


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
                .linkDistance(100)
                .linkStrength(0)
                .charge(0)
                .gravity(0)
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
