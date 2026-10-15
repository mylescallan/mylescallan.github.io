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
                    <li><a href="#Introduction">1. First Menu</a></li> \n \
                    <li><a href="#Users">2. Users/Permissions</a></li> \n \
                    <li><a href="#Blocks">3. Blocks</a></li> \n \
                    <li><a href="#Menus">4. Menus </a></li> \n \
                    <li><a href="#Other">5. Other Settings</a></li> \n \
                    <li><a href="#Fields">6. Fields</a></li> \n \
                    <li><a href="#Taxonomy">7. Taxonomy</a></li> \n \
                    <li><a href="#View">8. View Modes</a></li> \n \
                    <li><a href="#Fields">6. Fields</a></li> \n \
                </ul> \n \
            </div> \n \
        </div> \
        ' ;

         $( "body" ).prepend(input);
});