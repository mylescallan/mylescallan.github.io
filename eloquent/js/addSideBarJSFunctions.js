 /* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*  Add A Branch To The Body - Without Specifying Element
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

'use strict'
$(document).ready(function(){



    var input = '       \
        <div id="menuout"> \n \
             <div class="rotate270">Menu</div> \n \
               <div id="menuout_inner"> \n \
                <ul> \n \
                    <li><a href="#overview">1. Overview</a></li> \n \
                    <li><a href="#catfunc">2. Categories</a></li> \n \
                    <li><a href="#flowstack">3. Flow Control</a></li> \n \
                    <li><a href="#scope">4. Scope </a></li> \n \
                    <li><a href="#footnotes">5. Footnotes</a></li> \n \
                </ul> \n \
            </div> \n \
        </div> \
        ' ;

         $( "body" ).prepend(input);
});