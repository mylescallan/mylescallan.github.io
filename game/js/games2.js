/**
 * @author Myles
 */
"use strict"; // Ensure that all variables are declared

	// Mouse position information. NOTE: We use clientX and client Y instead of pageX and pageY 
	// in case the canvas is on a part of the page that the user has to scroll too.
	function handleMouseMove2(evt) {
		Game2.mousePosition = {
			x : evt.clientX,
			y : evt.clientY
		};
	}

	// For touchscreens: Finger position information
	function handleTouchMove2(evt) {
		Game2.mousePosition = {
			x : evt.clientX,
			y : evt.clientY
		};
		evt.preventDefault(); // Allows for touch events in areas where there may be links
	}
/*  
	// Mouse position information
	function handleMouseMove(evt) {
		Game2.mousePosition = {
			x : evt.pageX,
			y : evt.pageY
		};
	}

	// For touchscreens: Finger position information
	function handleTouchMove(evt) {
		Game2.mousePosition = {
			x : evt.pageX,
			y : evt.pageY
		};
		evt.preventDefault(); // Allows for touch events in areas where there may be links
	}
 */ 
// Create Game Object
var Game2 = {
	canvas : undefined,
	canvasContext : undefined,
	
	mousePosition : {x : 0, y : 0},
	rect : undefined,
	
	imageSprite : new Image(),
	imagePosition : {x : 0, y : 10},
	imageOrigin : {x: 0, y: 0}
};

// Create Game Method called "start"
Game2.start = function() {
	Game2.canvas = document.getElementById("myCanvas2");
	Game2.canvasContext = Game2.canvas.getContext("2d");
	
	Game2.imageSprite = new Image();
	Game2.imageSprite.src = "spr_deirdreHead.png";


	// Call the mouse/finger position event handlers, checking whether you are using a browser or iPhone or iPad
	if ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i))) {
		Game2.canvas.addEventListener('touchmove', handleTouchMove2);
	} else {
		Game2.canvas.addEventListener('mousemove', handleMouseMove2);
	}

	window.setTimeout(Game2.mainLoop, 500);
};

document.addEventListener('DOMContentLoaded', Game2.start);

// Create Game Method called "clearCanvas" (to ensure that previous "drawings" are erased)
Game2.clearCanvas = function() {
	Game2.canvasContext.clearRect(0, 0, Game2.canvas.width, Game2.canvas.height);
};

Game2.drawImage = function(sprite, position) {
	Game2.canvasContext.save();
	Game2.canvasContext.translate(position.x, position.y);
	Game2.canvasContext.drawImage(sprite, 0, 0, sprite.width, sprite.height, 0, 0, sprite.width, sprite.height);
	Game2.canvasContext.restore();
};

// Create Game Method called "update" called by "mainLoop"
	Game2.update = function() {

	// NOTE: If the canvas is not full screen, you have to find its "Bounding Rectangle" and adjust the mouse positon
	if (Game2.canvas.getBoundingClientRect) {        // Internet Explorer, Firefox 3+, Google Chrome, Opera 9.5+, Safari 4+
        Game2.rect = Game2.canvas.getBoundingClientRect ();
    }
   
    Game2.imageOrigin = {x : (Game2.imageSprite.width)/2, y : (Game2.imageSprite.height)/2}; // offset for image size

 	Game2.imagePosition = {x: Game2.mousePosition.x - Game2.rect.left - Game2.imageOrigin.x, y: Game2.mousePosition.y - Game2.rect.top - Game2.imageOrigin.y};
};


// Create Game Method called "draw" to create game objects, in this case a simple square.
Game2.draw = function() {
	Game2.drawImage(Game2.imageSprite, Game2.imagePosition);
};

// Create Game Method called "mainLoop" (the name is self explanitory)
Game2.mainLoop = function() {
	Game2.clearCanvas();
	Game2.update();
	Game2.draw();
	
	window.setTimeout(Game2.mainLoop, 1000 / 60); // refreshes the page about 60 times a second by reloading "mainLoop"
};