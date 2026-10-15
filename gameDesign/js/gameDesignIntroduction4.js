/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*      The Button Event Handler - 2nd to Last Attempt          *|
 |*            (compare this to final attempt!!)                 *|
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

var buttons = document.getElementsByClassName("expand"),
    details = document.getElementsByClassName("reveal"),
    i = 0;

function makeClickHandler(details, i) {
    "use strict";
    return function(evt) { // http://stackoverflow.com/questions/28054692/can-i-pass-more-arguments-into-event-handler-functions-in-javascript - still don't know why it works!!
        if (details[i].style.display === 'block') {
            details[i].style.display = 'none';
            buttons[i].innerHTML = "<em>Click Here:</em> To Expand The Source Code For This Section";
            buttons[i].style.opacity = "1";

            buttons[i].style.background = "-webkit-linear-gradient(top, #a3a3a3, #000)";
            buttons[i].style.background = "-moz-linear-gradient(top, #a3a3a3, #000)";
            buttons[i].style.background = "linear-gradient(top, #a3a3a3, #000)";
        } else {
            details[i].style.display = 'block';
            buttons[i].innerHTML = "<em>Click Here<em>: Don't Forget To Hide This Section, You've Read It";
            buttons[i].style.opacity = "0.5";

            buttons[i].style.background = "-webkit-linear-gradient(top, #DAA520, #000)";
            buttons[i].style.background = "-moz-linear-gradient(top, #DAA520, #000)";
            buttons[i].style.background = "linear-gradient(top, #DAA520, #000)";
        }
        // NOTE: Change innerHTML
    };
}

for (i; i < buttons.length; i++) {
    buttons[i].addEventListener("click", makeClickHandler(details, i), false);
}

