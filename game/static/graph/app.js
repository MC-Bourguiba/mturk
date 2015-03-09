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
    load_graph(name);
});


function load_graph(name) {
    $.ajax({
        url : "/graph/load_graph/",
        type : "GET",
        data : {
            'name': name
        },

        success : function(json) {
            graph_ui = JSON.parse(json['graph_ui']);
            editor_window = document.getElementById('graph-editor').contentWindow;

            for (i = 0; i < graph_ui.nodes.length; ++i) {
                graph_ui.nodes[i].weight = 1.0;
            }

            for (i = 0; i < graph_ui.links.length; ++i) {
                graph_ui.links[i].source.weight = 0;
                graph_ui.links[i].target.weight = 0;

                source_index = graph_ui.links[i].source.index;
                target_index = graph_ui.links[i].target.index;

                console.log(source_index);
                console.log(target_index);

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
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            // $('#results').html("<div class='alert-box alert radius' data-alert>Oops! We have encountered an error: "+errmsg+
            //     " <a href='#' class='close'>&times;</a></div>"); // add the error to the dom
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });

    // nodes = graph[0];
    // links = graph[1];
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
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            // $('#results').html("<div class='alert-box alert radius' data-alert>Oops! We have encountered an error: "+errmsg+
            //     " <a href='#' class='close'>&times;</a></div>"); // add the error to the dom
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
};
