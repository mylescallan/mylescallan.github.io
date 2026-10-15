var canvas = document.getElementById('myCanvas');
var context = canvas.getContext('2d');

function writeMessage(canvas, message, mousePos) {
	var context = canvas.getContext('2d');
	context.clearRect(0, 0, canvas.width, canvas.height);
	context.font = '18pt Calibri';
	context.fillStyle = 'white';
	context.fillText(message, mousePos.x, mousePos.y);
}

function getMousePos(canvas, evt) {
	var rect = canvas.getBoundingClientRect();
	return mousePos = {
		x : evt.clientX - rect.left,
		y : evt.clientY - rect.top
	};
}

canvas.addEventListener('mousemove', getMousePos(canvas, evt), false);

var message = 'Mouse position: ' + mousePos.x + ',' + mousePos.y;
writeMessage(canvas, message, mousePos);
