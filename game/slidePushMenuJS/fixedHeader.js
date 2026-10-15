$(window).scroll(function(){
    if ($(window).scrollTop() >= 120) {
       $('header').addClass('fixed-header');
    }
    else {
       $('header').removeClass('fixed-header');
    }
});