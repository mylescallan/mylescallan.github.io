/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*   The Button Event Handler
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

var divOuter = document.getElementsByClassName("divRevealOuter");
var divInner = document.getElementsByClassName("divRevealInner");
var i;

function makeClickHandler(divInner, i) {
    "use strict";
    return function() {
        if (divInner[i].style.display === 'block') {
            divInner[i].style.display = 'none';
            divOuter[i].style.opacity = "0.5";
        } else {
            divInner[i].style.display = 'block';
            divOuter[i].style.opacity = "1";
        }
        // NOTE: Change innerHTML
    };
}

for ( i = 0; i < divOuter.length; i++) {
    divOuter[i].addEventListener('click', makeClickHandler(divInner, i), false);
}

