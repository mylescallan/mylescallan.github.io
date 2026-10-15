/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*   The Button Event Handler - Final Working Attempt
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

// NOTE: This is equivalent to gameDesignIntroduction1.js - where I appeared to have an event handler with arguments, but really the event handler was hidden in an enclosing function
// Still haven't internalized this difference yet, but at least I got to the bottom of it!!

var buttons = document.getElementsByClassName("expand"),
    details = document.getElementsByClassName("reveal"),
    i;

function addClickHandler(buttons, details) {
    function myHandler(event) {
        if (details.style.display === 'block') {
            details.style.display = 'none';
            buttons.innerHTML = "<em>Click Here:</em> To Expand The Source Code For This Section";
            buttons.style.opacity = "1";

            buttons.style.background = "-webkit-linear-gradient(top, #a3a3a3, #000)";
            buttons.style.background = "-moz-linear-gradient(top, #a3a3a3, #000)";
            buttons.style.background = "linear-gradient(top, #a3a3a3, #000)";
        } else {
            details.style.display = 'block';
            buttons.innerHTML = "<em>Click Here<em>: Don't Forget To Hide This Section, You've Read It";
            buttons.style.opacity = "0.5";

            buttons.style.background = "-webkit-linear-gradient(top, #DAA520, #000)";
            buttons.style.background = "-moz-linear-gradient(top, #DAA520, #000)";
            buttons.style.background = "linear-gradient(top, #DAA520, #000)";
        }
        // NOTE: Change innerHTML
    }
    buttons.addEventListener("click", myHandler, false);
    //                               no call here ^ (that's what is said everywhere)
}

for ( i = 0; i < buttons.length; i++) {
    addClickHandler(buttons[i], details[i]);
}