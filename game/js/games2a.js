/**
 * @author Myles
 */
"use strict"; // Ensure that all variables are declared

	// Mouse position information. NOTE: We use clientX and client Y instead of pageX and pageY 
	// in case the canvas is on a part of the page that the user has to scroll too.
	function handleMouseMove(evt) {
		Game2a.mousePosition = {
			x : evt.clientX,
			y : evt.clientY
		};
	}

	// For touchscreens: Finger position information
	function handleTouchMove(evt) {
		Game2a.mousePosition = {
			x : evt.clientX,
			y : evt.clientY
		};
		evt.preventDefault(); // Allows for touch events in areas where there may be links
	}
/*  
	// Mouse position information
	function handleMouseMove(evt) {
		Game2a.mousePosition = {
			x : evt.pageX,
			y : evt.pageY
		};
	}

	// For touchscreens: Finger position information
	function handleTouchMove(evt) {
		Game2a.mousePosition = {
			x : evt.pageX,
			y : evt.pageY
		};
		evt.preventDefault(); // Allows for touch events in areas where there may be links
	}
 */ 
// Create Game Object
var Game2a = {
	canvas : undefined,
	canvasContext : undefined,
	
	mousePosition : {x : 0, y : 0},
	rect : undefined,
	
	imageSprite : new Image(),
	imagePosition : {x : 0, y : 10},
	imageOrigin : {x: 0, y: 0}
};

// Create Game Method called "start"
Game2a.start = function() {
	Game2a.canvas = document.getElementById("myCanvas2a");
	Game2a.canvasContext = Game2a.canvas.getContext("2d");
	
	Game2a.imageSprite = new Image();
	Game2a.imageSprite.src = "spr_deirdreHead2.png";


	// Call the mouse/finger position event handlers, checking whether you are using a browser or iPhone or iPad
	if ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i))) {
		Game2a.canvas.addEventListener('touchmove', handleTouchMove);
	} else {
		Game2a.canvas.addEventListener('mousemove', handleMouseMove);
	}

	window.setTimeout(Game2a.mainLoop, 500);
};

document.addEventListener('DOMContentLoaded', Game2a.start);

// Create Game Method called "clearCanvas" (to ensure that previous "drawings" are erased)
Game2a.clearCanvas = function() {
	Game2a.canvasContext.clearRect(0, 0, Game2a.canvas.width, Game2a.canvas.height);
};

Game2a.drawImage = function(sprite, position) {
	Game2a.canvasContext.save();
	Game2a.canvasContext.translate(position.x, position.y);
	Game2a.canvasContext.drawImage(sprite, 0, 0, sprite.width, sprite.height, 0, 0, sprite.width, sprite.height);
	Game2a.canvasContext.restore();
};

// Create Game Method called "update" called by "mainLoop"
	Game2a.update = function() {

	// NOTE: If the canvas is not full screen, you have to find its "Bounding Rectangle" and adjust the mouse positon
	if (Game2a.canvas.getBoundingClientRect) {        // Internet Explorer, Firefox 3+, Google Chrome, Opera 9.5+, Safari 4+
        Game2a.rect = Game2a.canvas.getBoundingClientRect ();
    }
   
    Game2a.imageOrigin = {x : (Game2a.imageSprite.width)/2, y : (Game2a.imageSprite.height)/2}; // offset for image size

 	Game2a.imagePosition = {x: Game2a.mousePosition.x - Game2a.rect.left - Game2a.imageOrigin.x, y: Game2a.mousePosition.y - Game2a.rect.top - Game2a.imageOrigin.y};
};


// Create Game Method called "draw" to create game objects, in this case a simple square.
Game2a.draw = function() {
	Game2a.drawImage(Game2a.imageSprite, Game2a.imagePosition);
};

// Create Game Method called "mainLoop" (the name is self explanitory)
Game2a.mainLoop = function() {
	Game2a.clearCanvas();
	Game2a.update();
	Game2a.draw();
	
	window.setTimeout(Game2a.mainLoop, 1000 / 60); // refreshes the page about 60 times a second by reloading "mainLoop"
};