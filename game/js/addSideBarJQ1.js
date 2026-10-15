 /* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*  Add A Branch To The Body - Without Specifying Element
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

'use strict'
$(document).ready(function(){



 	var input = '		\
		<div id="menuout"> \n \
			Menu \n \
			<div id="menuout_inner"> \n \
				<ul> \n \
					<li><a href="#Introduction">Introduction</a></li> \n \
					<li><a href="#ObjectsI">Objects: Overview</a></li> \n \
					<li><a href="#ObjectsII">Objects: The Details</a></li> \n \
					<li><a href="#Types">Types</a></li> \n \
					<li><a href="#GamesI">Games: Overview</a></li> \n \
					<li><a href="#GamesII">Games: Methods</a></li> \n \
				</ul> \n \
			</div> \n \
		</div> \
		' ;

		 $( "body" ).prepend(input);
});