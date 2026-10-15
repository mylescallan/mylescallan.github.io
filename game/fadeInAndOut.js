$(document).ready(function () {

    var flag = $(window).scrollTop() > 20 ? 1 : 2;
    $(window).scroll(function () {
        var scrollTop = $(window).scrollTop();
        if (scrollTop > 20 && flag != 1) {
            $("h1").fadeTo("slow", ".05");
            flag = 1;
            console.log('t1')
        } else if (scrollTop <= 20 && flag != 2) {
            $("h1").fadeTo("slow", "1");
            flag = 2;
            console.log('t2')
        }
    });

});