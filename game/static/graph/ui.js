$('.list-group a').click(function(e) {
    var $this = $(this);
    var parent_div = $this.parent();

    parent_div.children().each(function(i){
        $(this).removeClass('active');
    });

    $this.addClass('active');
    e.preventDefault();
});
