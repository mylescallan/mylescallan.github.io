
var d = document;
var docBody = d.getElementsByTagName("body")[0];


var sideBarText ='<div id="menuout"> \
			Menu \
			<div id="menuout_inner"> \
				<ul> \
					<li><a href="#Introduction">Introduction</a></li> \
					<li><a href="#ObjectsI">Objects: Overview</a></li> \
					<li><a href="#ObjectsII">Objects: The Details</a></li> \
					<li><a href="#Types">Types</a></li> \
					<li><a href="#GamesI">Games: Overview</a></li> \
					<li><a href="#GamesII">Games: Methods</a></li> \
				</ul> \
			</div> \
		</div> ';


var MyText = document.createTextNode(sideBarText);		
docBody.appendChild(MyText);
