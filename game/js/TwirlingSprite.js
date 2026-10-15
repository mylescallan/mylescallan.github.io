"use strict";
// Mouse position information
function handleMouseMove(evt) {
    Game.mousePosition = { x : evt.pageX, y : evt.pageY };
}

// For touchscreens: Finger position information
function handleTouchMove (evt){ 
	Game.mousePosition = { x : evt.pageX, y : evt.pageY };
	evt.preventDefault(); // Allows for touch events in areas where there may be links
}


var Game = {
	canvas : undefined,
	canvasContext : undefined,
	backgroundSprite : undefined,
	imageSprite : undefined,
	rect : undefined,
	imageOrigin:{x: 0, y: 0},
	
	mousePosition : {x : 0, y : 0},
	imagePosition : {x : 0, y : 0},
	
	// Code for image rotation
    imageOrigin : { x : 0, y :  0},
    imageRotation : 0

};

Game.start = function() {
	Game.canvas = document.getElementById("myCanvas");
	Game.canvasContext = Game.canvas.getContext("2d");
	
	Game.backgroundSprite = new Image();
	Game.backgroundSprite.src = "spr_background.jpg";
	Game.imageSprite = new Image();
	Game.imageSprite.src = "spr_image.png";


	// Call the mouse/finger position event handlers, checking whether you are using a browser or iPhone or iPad
	if ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i))) {
		Game.canvas.addEventListener('touchmove', handleTouchMove);
	} else {
		Game.canvas.onmousemove = handleMouseMove;
	}
	
	// NOTE: If the canvas is not full screen, you have to find its "Bounding Rectangle" and adjust the mouse positon
	if (Game.canvas.getBoundingClientRect) {        // Internet Explorer, Firefox 3+, Google Chrome, Opera 9.5+, Safari 4+
        Game.rect = Game.canvas.getBoundingClientRect ();
    }
 
	window.setTimeout(Game.mainLoop, 500);
};

document.addEventListener('DOMContentLoaded', Game.start);

Game.clearCanvas = function() {
	Game.canvasContext.clearRect(0, 0, Game.canvas.width, Game.canvas.height);
};

Game.drawImage = function(sprite, position, rotation, origin) {
	Game.canvasContext.save();
	Game.canvasContext.translate(position.x, position.y);
	Game.canvasContext.rotate(rotation);
	Game.canvasContext.drawImage(sprite, 0, 0, sprite.width, sprite.height,  - origin.x, - origin.y, sprite.width, sprite.height);
	Game.canvasContext.restore();
};

Game.update = function() {

    var opposite = (Game.mousePosition.y - Game.rect.top ) - Game.imagePosition.y;
    var adjacent = (Game.mousePosition.x - Game.rect.left) - Game.imagePosition.x;
    Game.imageRotation = Math.atan2(opposite, adjacent);
};

Game.draw = function() {

    Game.imagePosition = {x : (Game.backgroundSprite.width/2), y : (Game.backgroundSprite.height/2)};
  	Game.imageOrigin = {x : (Game.imageSprite.width/4), y : (Game.imageSprite.height/4)}; // offset for image size
    Game.clearCanvas();

    Game.drawImage(Game.backgroundSprite, { x : 0, y : 0 }, 0, { x : 0, y : 0 });
    Game.drawImage(Game.imageSprite, Game.imagePosition, Game.imageRotation, Game.imageOrigin);
}; 

Game.mainLoop = function() {
	Game.update();
	Game.draw();
    
	window.setTimeout(Game.mainLoop, 1000 / 60);
};


