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

$(document).ready(function() {
setInterval(get_countdown ,1000);
setInterval(heartbeat_loop,1000);
});

function get_username() {
    return $("#user")[0].value;
}

function get_countdown(){
$.ajax({
        url : "/graph/get_countdown/",
        type : "GET",

        success : function(json) {
            console.log(json);
            if(json['game_left']){
            console.log("test");
            }
            else if(json['countdown']>=0){
            console.log("countdown");
            document.getElementById("wait").innerHTML=json['countdown'];
            }

            else if(json['started']){
            console.log("game has started");
            window.location.reload();
            }
            else if
            (json['game_left']){
            console.log("test");
            }
            else{
            document.getElementById("wait").innerHTML=0;
            }
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });

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
        }

    });
}

function start_heartbeat_loop() {
    setTimeout(start_heartbeat_loop, 1000); // Update every second.
    heartbeat_loop();


}


$.ajaxSetup({
    beforeSend: function(xhr, settings) {
        if (!csrfSafeMethod(settings.type) && sameOrigin(settings.url)) {
            // Send the token to same-origin, relative URLs only.
            // Send the token only if the method warrants CSRF protection
            // Using the CSRFToken value acquired earlier
            xhr.setRequestHeader("X-CSRFToken", getCookie("csrftoken"));
        }
    }
});

csrftoken = getCookie('csrftoken');