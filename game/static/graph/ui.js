function listActivate($this, e) {
    var parent_div = $this.parent();

    parent_div.children().each(function(i){
        $(this).removeClass('active');
    });

    $this.addClass('active');
    e.preventDefault();
}

$('.list-group a').click(function(e) {
    listActivate($(this), e);
});


$('#model-display-list a').click(function(e) {
    listActivate($(this), e);
    $("#user-operation-pane").removeClass('hidden');
});


function printValue(sliderID, textbox) {
    var x = document.getElementById(textbox);
    var y = document.getElementById(sliderID);
    x.value = y.value;
}


$('.btn-toggle').click(function() {
    $(this).find('.btn').toggleClass('active');

    if ($(this).find('.btn-primary').size()>0) {
    	$(this).find('.btn').toggleClass('btn-primary');
    }
    if ($(this).find('.btn-danger').size()>0) {
    	$(this).find('.btn').toggleClass('btn-danger');
    }
    if ($(this).find('.btn-success').size()>0) {
    	$(this).find('.btn').toggleClass('btn-success');
    }
    if ($(this).find('.btn-info').size()>0) {
    	$(this).find('.btn').toggleClass('btn-info');
    }

    $(this).find('.btn').toggleClass('btn-default');

});


$("#graph-user-btn").click(function() {
    if ($(this).find("#show-graphs-btn").hasClass("active")) {
        $("#graph-list-display").removeClass("hidden");
        $("#user-list-display").addClass("hidden");
    } else {
        $("#user-list-display").removeClass("hidden");
        $("#graph-list-display").addClass("hidden");
    }
});
