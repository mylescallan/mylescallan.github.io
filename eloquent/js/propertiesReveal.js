/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*   The Button Event Handler - Final Working Attempt
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

// NOTE: This is equivalent to gameDesignIntroduction1.js - where I appeared to have an event handler with arguments, but really the event handler was hidden in an enclosing function
// Still haven't internalized this difference yet, but at least I got to the bottom of it!!
//
// In hindsight, gameDesignIntroduction1.js may be the more standard way of writing this code. As the only role of "addClickHandler" is to return the actual event handler (myHandler)
(function(){
var buttons = document.getElementsByClassName("expand"),
    details = document.getElementsByClassName("reveal"),
    i;

function addClickHandler(buttons, details) {
    'use strict';
    function myHandler(event) {
        if (details.style.display === 'block') {
            details.style.display = 'none';
            buttons.style.opacity = "1";

        } else {
            details.style.display = 'block';
            buttons.style.opacity = "0.5";
        }
        // NOTE: Change innerHTML
    }
   return buttons.addEventListener("click", myHandler, false);
//                               no call here ^ (that's what is said everywhere)
}

for ( i = 0; i < buttons.length; i++) {
    addClickHandler(buttons[i], details[i]);
}
}());