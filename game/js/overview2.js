/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*   The Button Event Handler
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */
 
    
(function() {
    var buttons = document.getElementsByClassName("expand"),
        details = document.getElementsByClassName("reveal");
    for (i in buttons) {
        function makeClickHandler(details, i) {
            "use strict";
            return function() {
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


        buttons[i].addEventListener("click", function() {
            makeClickHandler(details, i);
        }, false);
    }
})

