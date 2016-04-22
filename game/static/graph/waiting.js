

$(document).ready(function() {
setInterval(get_countdown ,1000);

});



function get_countdown(){
$.ajax({
        url : "/graph/get_countdown/",
        type : "GET",

        success : function(json) {
            console.log(json);
            document.getElementById("wait").innerHTML=json['countdown'];
            if(json['countdown']<0){
            window.location.reload();
            }
        },

        // handle a non-successful response
        error : function(xhr,errmsg,err) {
            console.log(xhr.status + ": " + xhr.responseText); // provide a bit more info about the error to the console
        }
    });

}