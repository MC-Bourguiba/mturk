var graph_window = document.getElementById("graph-editor");
var generated_paths = [];
var path_ids = [];

function on_node_selected(selected_node) {

}

function on_edge_selected(selected_edge) {

}


$("#submit-game-btn").click(function(e) {
    e.preventDefault();

    var paths = [];
    var allocation = [];

    $("#path-list tr").each(function(idx, li) {
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


function update_ui() {
    setTimeout(update_ui, 10000); // Update every 10 seconds
    update_from_state($("#username-hidden")[0].value);
}


$(document).ready(function() {
    username = $("#username-hidden")[0].value;
    update_paths(username);
    update_previous_cost(username);
    update_ui();
});


function update_from_state(username) {
    $.ajax({
        url : "/graph/current_state/" + username + "/",
        type : "GET",

        success : function(json) {
            if (json['completed_task']) {
                if (!json['turn_completed']) {
                    $("#path-btns").toggle(false);
                    $("#completed-turn").toggle(true);
                } else {
                    $("#path-btns").toggle(true);
                    update_paths(username);
                    update_previous_cost(username);
                }
            }

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

            $('#path-list tr  a').click(function(e) {
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
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });
}
