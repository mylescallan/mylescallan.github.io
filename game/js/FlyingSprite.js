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
	imageOrigin:{x: 0, y: 0},
	
	mousePosition : {x : 0, y : 0},
	
	imagePosition : {x : 0, y : 150},
	imagePosition1 : {x : 0, y : 250},
	imagePosition2 : {x : 0, y : 350},
	imagePosition3 : {x : 0, y : 250},
	imagePosition4 : {x : 0, y : 0}
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

	window.setTimeout(Game.mainLoop, 500);
};

document.addEventListener('DOMContentLoaded', Game.start);

Game.clearCanvas = function() {
	Game.canvasContext.clearRect(0, 0, Game.canvas.width, Game.canvas.height);
};

Game.drawImage = function(sprite, position) {
	Game.canvasContext.save();
	Game.canvasContext.translate(position.x, position.y);
	Game.canvasContext.drawImage(sprite, 0, 0, sprite.width, sprite.height, - Game.imageOrigin.x, - Game.imageOrigin.y, sprite.width, sprite.height);
	Game.canvasContext.restore();
};

Game.update = function() {
	// NOTE: If the canvas is not full screen, you have to find its "Bounding Rectangle" and adjust the mouse positon
	if (Game.canvas.getBoundingClientRect) {        // Internet Explorer, Firefox 3+, Google Chrome, Opera 9.5+, Safari 4+
        var rect = Game.canvas.getBoundingClientRect ();
    }

   	Game.imageOrigin = {x : (Game.imageSprite.width)/4, y : (Game.imageSprite.height)/4}; // offset for image size

	var d = new Date(); // Use getTime to generate motion

	Game.imagePosition.x = d.getTime() * 0.1 % Game.canvas.width;
	Game.imagePosition1.x = Game.canvas.width - (d.getTime() * 0.2 % Game.canvas.width);
	Game.imagePosition2.x = d.getTime() * 0.25 % Game.canvas.width;
	Game.imagePosition2.y = Game.canvas.height - (d.getTime() * 0.25) % Game.canvas.height;
	Game.imagePosition3.x = d.getTime() * 0.3 % Game.canvas.width;
	Game.imagePosition3.y = d.getTime() * 0.3 % Game.canvas.height;
 	Game.imagePosition4 = {x: Game.mousePosition.x - rect.left - Game.imageOrigin.x, y: Game.mousePosition.y - rect.top - Game.imageOrigin.y};
};

Game.draw = function() {
	Game.drawImage(Game.backgroundSprite, {x : 0, y : 0});
	Game.drawImage(Game.imageSprite, Game.imagePosition);
	Game.drawImage(Game.imageSprite, Game.imagePosition1);
	Game.drawImage(Game.imageSprite, Game.imagePosition2);
	Game.drawImage(Game.imageSprite, Game.imagePosition3);
	Game.drawImage(Game.imageSprite, Game.imagePosition4);
}; 

Game.mainLoop = function() {
	Game.clearCanvas();
	Game.update();
	Game.draw();
	
	window.setTimeout(Game.mainLoop, 1000 / 60);
};
