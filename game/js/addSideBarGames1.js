 /* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*  Add A Branch To The Body - Without Specifying Element
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

'use strict'
$(document).ready(function(){



    var input = '       \
        <div id="menuout"> \n \
            Menu \n \
            <div id="menuout_inner"> \n \
                <ul> \n \
                    <li><a href="#Introduction">1. Introduction</a></li> \n \
                    <li><a href="#button">2. Create Button (CSS)</a></li> \n \
                    <li><a href="#event">3. Attach Event (HTML)</a></li> \n \
                    <li><a href="#eventListener">4. Event Listener (JS)</a></li> \n \
                    <li><a href="#changeStyle">5. Change CSS Style (JS)s</a></li> \n \
                    <li><a href="#transition">6. Transition (CSS)</a></li> \n \
                    <li><a href="#conclusion">7. Conclusion</a></li> \n \
                </ul> \n \
            </div> \n \
        </div> \
        ' ;

         $( "body" ).prepend(input);
});