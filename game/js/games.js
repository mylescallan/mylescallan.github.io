/**
 * @author Myles
 */
"use strict"; // Ensure that all variables are declared

// Create Game Object
var Game = {
	canvas : undefined,
	canvasContext : undefined,
	rectanglePosition : 0
};

// Create Game Method called "start"
Game.start = function() {
	Game.canvas = document.getElementById("myCanvas");
	Game.canvasContext = Game.canvas.getContext("2d");
	Game.mainLoop();
};

document.addEventListener('DOMContentLoaded', Game.start);

// Create Game Method called "clearCanvas" (to ensure that previous "drawings" are erased)
Game.clearCanvas = function() {
	Game.canvasContext.clearRect(0, 0, Game.canvas.width, Game.canvas.height);
};

// Create Game Method called "mainLoop" (the name is self explanitory)
Game.mainLoop = function() {
	Game.clearCanvas();
	Game.update();
	Game.draw();
	
	window.setTimeout(Game.mainLoop, 1000 / 60); // refreshes the page about 60 times a second by reloading "mainLoop"
};

// Create Game Method called "update" called by "mainLoop"
Game.update = function() {
	var d = new Date();
	Game.rectanglePosition = (d.getTime()/100) % Game.canvas.width; // (1) changes the rectangle position using modulus
	                                                          // to ensure that the rectangle is within the canvas width
//  Game.rectanglePosition = Game.canvas.width - (d.getTime() % Game.canvas.width)	// backwards motion (right to left)
};

// Create Game Method called "draw" to create game objects, in this case a simple square.
Game.draw = function() {
	Game.canvasContext.fillStyle = "red";
	Game.canvasContext.fillRect(Game.rectanglePosition, 10, 5, 5); // move horizontally
//	Game.canvasContext.fillRect(100, Game.rectanglePosition, 50, 50); // move vertically≈
//	Game.canvasContext.fillRect(Game.rectanglePosition, Game.rectanglePosition, 50, 50); // (2) move diagonally (from top left)
	                                                                                     // or (bottom right depending on (1))

};

