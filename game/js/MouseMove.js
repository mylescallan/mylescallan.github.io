"use strict";
// Mouse position information
function getMouseMove(evt) {
    this.mousePosition = { x : evt.pageX, y : evt.pageY };
}

// For touchscreens: Finger position information
function getTouchMove (evt){ 
	this.mousePosition = { x : evt.pageX, y : evt.pageY };
	evt.preventDefault(); // Allows for touch events in areas where there may be links
}
