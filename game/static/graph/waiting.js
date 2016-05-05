

$(document).ready(function() {
setInterval(get_countdown ,1000);
//start_heartbeat_loop();
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
            if(json['started']){
            window.location.reload();
            }
            if(json['countdown']>=0){
            document.getElementById("wait").innerHTML=json['countdown'];
            }
            else{
            document.getElementById("wait").innerHTML=0;
            setTimeout(window.location.reload(),2000);
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
