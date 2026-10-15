 /* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*  Add A Branch To The Body - Without Specifying Element
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */
(function(){
'use strict'
$(document).ready(function(){



    var input = '       \
        <div id="menuout"> \n \
            Menu \n \
            <div id="menuout_inner"> \n \
                <ul> \n \
                    <li><a href="#Introduction">1. Introduction</a></li> \n \
                    <li><a href="#steps">2. Step-By-Step</a></li> \n \
                    <li><a href="#button">3. Create Button (CSS)</a></li> \n \
                    <li><a href="#event">4. Event Listener (JS)</a></li> \n \
                    <li><a href="#eventListener">5. Reveal Section (JS)</a></li> \n \
                    <li><a href="#transition">6. Transition (CSS)</a></li> \n \
                    <li><a href="#conclusion">7. Conclusion</a></li> \n \
                    <li><a href="#footnotes">8. Footnotes</a></li> \n \
                </ul> \n \
            </div> \n \
        </div> \
        ' ;

         $( "body" ).prepend(input);
});
}());