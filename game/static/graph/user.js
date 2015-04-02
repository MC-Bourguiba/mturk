var graph_window = document.getElementById("graph-editor");
var generated_paths = [];
var path_ids = [];

function on_node_selected(selected_node) {

}

function on_edge_selected(selected_edge) {

}


// $("#start-game-btn").click(function() {
//     $.ajax({
//         url : "/graph/generate_paths/",
//         type : "GET",
//         data : {
//             'graph': $("#graph-hidden")[0].value,
//             'source': $("#source-hidden")[0].value,
//             'destination': $("#destination-hidden")[0].value
//         },

//         success : function(json) {
//             paths = json.paths;
//             generated_paths = paths;
//             $("#path-display-list").html(json.html);
//             $("a[id*='path-list']").on('click', function(e) {
//                 e.preventDefault();
//                 var match = path_list_regex.exec(this.id);
//                 var num = match[1];
//                 editor_window.highlighted_links = generated_paths[num];
//                 editor_window.restart();
//             });

//             $("#path-btns").removeClass("hidden");
//             $("#path-display").show();
//         },

//         // handle a non-successful response
//         error : function(xhr,errmsg,err) {
//             console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
//         }
//     });
// });


$("#submit-game-btn").click(function(e) {
    e.preventDefault();

    var paths = [];
    var allocation = [];

    $("#path-list li").each(function(idx, li) {
        paths.push(parseInt($(li).find("a").attr('id')));
        allocation.push(parseFloat($(li).find("input")[1].value));
    });

    console.log(paths);
    console.log(allocation);

    $.ajax({
        url : "/graph/submit_distribution/",
        type : "POST",
        data : JSON.stringify({
            "username" : $("#username-hidden")[0].value,
            "allocation" : allocation,
            "ids" : paths
        }),

        success : function(json) {
            console.log(json);
            update_from_state($("#username-hidden")[0].value);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
});


graph_window.onload = function() {
    console.log($("#graph-hidden")[0].value);
    load_graph($("#graph-hidden")[0].value);
};


$(document).ready(function() {
    update_from_state($("#username-hidden")[0].value);
});


function update_from_state(username) {
    $.ajax({
        url : "/graph/current_state/" + username + "/",
        type : "GET",

        success : function(json) {
            if (json['completed_task'] && !json['turn_completed']) {
                $("#path-btns").toggle(false);
                $("#completed-turn").toggle(true);
            } else {
                $("#path-btns").toggle(true);
            }

            update_paths(username);
            console.log(json);
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}


function update_paths(username) {
    $.ajax({
        url : "/graph/get_paths/" + username + "/",
        type : "GET",

        success : function(json) {
            console.log(json);
            generated_paths = json['paths'];
            console.log(generated_paths);
            path_ids = json['path_ids'];

            $("#path-display-list").html(json['html']);

            $('#path-list li  a').click(function(e) {
                e.preventDefault();
                // This is soooooooo bad
                var num = parseInt($(this).html().substr('Path '.length));
                console.log(num);
                editor_window = document.getElementById("graph-editor").contentWindow;
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
