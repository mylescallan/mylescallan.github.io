"use strict";

var Game = {
	canvas : undefined,
	canvasContext : undefined,
	backgroundSprite : undefined,
	imageSprite : undefined,
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
	window.setTimeout(Game.mainLoop, 500);
};

document.addEventListener('DOMContentLoaded', Game.start);




Game.clearCanvas = function() {
	Game.canvasContext.clearRect(0, 0, Game.canvas.width, Game.canvas.height);
};

Game.drawImage = function(sprite, position) {
	Game.canvasContext.save();
	Game.canvasContext.translate(position.x, position.y);
	Game.canvasContext.drawImage(sprite, 0, 0, sprite.width, sprite.height, 0, 0, sprite.width, sprite.height);
	Game.canvasContext.restore();
};

Game.mainLoop = function() {
	Game.clearCanvas();
	Game.update();
	Game.draw();
	window.setTimeout(Game.mainLoop, 1000 / 60);
};

Game.update = function() {
	var d = new Date();
	Game.imagePosition.x = d.getTime() * 0.1 % Game.canvas.width;
	Game.imagePosition1.x = Game.canvas.width - (d.getTime() * 0.2 % Game.canvas.width);
	Game.imagePosition2.x = d.getTime() * 0.25 % Game.canvas.width;
	Game.imagePosition2.y = Game.canvas.height - (d.getTime() * 0.25) % Game.canvas.height;
	Game.imagePosition3.x = d.getTime() * 0.3 % Game.canvas.width;
	Game.imagePosition3.y = d.getTime() * 0.3 % Game.canvas.height;
	document.onmousemove = mouseCoords; 
    function mouseCoords(ev){
    Game.imagePosition4 = {x:ev.pageX, y:ev.pageY};
};

};

Game.draw = function() {
	Game.drawImage(Game.backgroundSprite, {
		x : 0,
		y : 0
	});
	Game.drawImage(Game.imageSprite, Game.imagePosition);
	Game.drawImage(Game.imageSprite, Game.imagePosition1);
	Game.drawImage(Game.imageSprite, Game.imagePosition2);
	Game.drawImage(Game.imageSprite, Game.imagePosition3);
	Game.drawImage(Game.imageSprite, Game.imagePosition4);
}; 