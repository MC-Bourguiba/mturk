$('#start-game-btn').click(function(evt) {
    start_game();
});


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


function on_node_selected(selected_node) {

}

function on_edge_selected(selected_edge) {

}


$(document).ready(function() {
    console.log($("#graph-hidden")[0].value);
    load_graph($("#graph-hidden")[0].value);
});
