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
                    <li><a href="#html">2. HTML</a></li> \n \
                    <li><a href="#css">3. CSS</a></li> \n \
                    <li><a href="#javascript">4. Javascript</a></li> \n \
                    <li><a href="#conclusion">6. Conclusion</a></li> \n \
                </ul> \n \
            </div> \n \
        </div> \
        ' ;

         $( "body" ).prepend(input);
});