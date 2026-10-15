/**
 * @author Myles
 */
"use strict"; // Ensure that all variables are declared

// Create Game Object
var Game1 = {
	canvas : undefined,
	canvasContext : undefined,
	imageSprite : new Image(),
	imagePosition : {x : 0, y : 10}
};

// Create Game Method called "start"
Game1.start = function() {
	Game1.canvas = document.getElementById("myCanvas1");
	Game1.canvasContext = Game1.canvas.getContext("2d");
	
	Game1.imageSprite = new Image();
	Game1.imageSprite.src = 'spr_deirdreHead.png';
	
	window.setTimeout(Game1.mainLoop, 500);
};

document.addEventListener('DOMContentLoaded', Game1.start);

// Create Game Method called "clearCanvas" (to ensure that previous "drawings" are erased)
Game1.clearCanvas = function() {
	Game1.canvasContext.clearRect(0, 0, Game1.canvas.width, Game1.canvas.height);
};

// Create Game Method called "drawImage" (to )
Game1.drawImage = function(sprite, position) {
	Game1.canvasContext.save();
	Game1.canvasContext.translate(position.x, position.y);
	Game1.canvasContext.drawImage(sprite, 0, 0, sprite.width, sprite.height, 0 , 0, sprite.width, sprite.height);
	Game1.canvasContext.restore();
};

// Create Game Method called "update" called by "mainLoop"
Game1.update = function() {
	var d = new Date();
	Game1.imagePosition.x = d.getTime() * 0.1 % Game1.canvas.width;
};

// Create Game Method called "draw" to create game objects, in this case a single Image.
Game1.draw = function() {
	Game1.drawImage(Game1.imageSprite, Game1.imagePosition);
};

// Create Game Method called "mainLoop" (the name is self explanitory)
Game1.mainLoop = function() {
	Game1.clearCanvas();
	Game1.update();
	Game1.draw();
	
	window.setTimeout(Game1.mainLoop, 1000 / 60); // refreshes the page about 60 times a second by reloading "mainLoop"
};