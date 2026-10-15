"use strict";
 
 // Mouse position information
function getMouseMove(evt) {
    Game4.mousePosition = { x : evt.pageX, y : evt.pageY };
}

// For touchscreens: Finger position information
function getTouchMove (evt){ 
	Game4.mousePosition = { x : evt.pageX, y : evt.pageY };
	evt.preventDefault(); // Allows for touch events in areas where there may be links
}


var Game4 = {
	canvas : undefined,
	canvasContext : undefined,
	backgroundSprite : undefined,
	imageSprite : undefined,
	rect : undefined,
	
	mousePosition : {x : 0, y : 0},
	imagePosition : {x : 0, y : 0},
	
	// Code for image rotation
    imageOrigin : { x : 0, y :  0},
    imageRotation : 0

};

Game4.start = function() {
	Game4.canvas = document.getElementById("myCanvas4");
	Game4.canvasContext = Game4.canvas.getContext("2d");
	
	Game4.imageSprite = new Image();
	Game4.imageSprite.src = "spr_image.png";


	// Call the mouse/finger position event handlers, checking whether you are using a browser or iPhone or iPad
	if ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i))) {
		Game4.canvas.addEventListener('touchmove', getTouchMove);
	} else {
		Game4.canvas.addEventListener('mousemove', getMouseMove);
	}
	
	// NOTE: If the canvas is not full screen, you have to find its "Bounding Rectangle" and adjust the mouse positon
	if (Game4.canvas.getBoundingClientRect) {        // Internet Explorer, Firefox 3+, Google Chrome, Opera 9.5+, Safari 4+
        Game4.rect = Game4.canvas.getBoundingClientRect ();
    }
	
	window.setTimeout(Game4.mainLoop, 500);
};

document.addEventListener('DOMContentLoaded', Game4.start);

Game4.clearCanvas = function() {
	Game4.canvasContext.clearRect(0, 0, Game4.canvas.width, Game4.canvas.height);
};

Game4.drawImage = function(sprite, position, rotation, origin) {
	Game4.canvasContext.save();
	Game4.canvasContext.translate(position.x, position.y);
	Game4.canvasContext.rotate(rotation);
	Game4.canvasContext.drawImage(sprite, 0, 0, sprite.width, sprite.height,  - origin.x, - origin.y, sprite.width, sprite.height);
	Game4.canvasContext.restore();
};

Game4.update = function() {

    var opposite = (Game4.mousePosition.y - Game4.rect.top ) - Game4.imagePosition.y;
    var adjacent = (Game4.mousePosition.x - Game4.rect.left) - Game4.imagePosition.x;
    Game4.imageRotation = Math.atan2(opposite, adjacent);
};

Game4.draw = function() {

    Game4.imagePosition = {x : (Game4.canvas.width/2), y : (Game4.canvas.height/2)};
  	Game4.imageOrigin = {x : (Game4.imageSprite.width/4), y : (Game4.imageSprite.height/4)}; // offset for image size
    Game4.clearCanvas();

    Game4.drawImage(Game4.imageSprite, Game4.imagePosition, Game4.imageRotation, Game4.imageOrigin);
}; 

Game4.mainLoop = function() {
	Game4.update();
	Game4.draw();
    
	window.setTimeout(Game4.mainLoop, 1000 / 60);
};


