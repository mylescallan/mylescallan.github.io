var canvas = document.getElementById('myCanvas');

function writeMessage(canvas, message, mousePos) {
	var context = canvas.getContext('2d');
	context.clearRect(0, 0, canvas.width, canvas.height);
	context.font = '18pt Calibri';
	context.fillStyle = 'white';
	context.fillText(message, mousePos.x, mousePos.y);
}

function getMousePos(canvas, evt) {
	var rect = canvas.getBoundingClientRect();
	var mousePos = [];
	mousePos[0] = evt.clientX - rect.left;
	mousePos[1] = evt.clientY - rect.top;
	mousePos[2] = evt.clientX;
	mousePos[3] = evt.clientY;
	return mousePos;
}

canvas.addEventListener('mousemove', function(evt) {
	var mousePos = getMousePos(canvas, evt);
	}
	, false);


	var message = 'Canvas Mouse position: ' + mousePos[0] + ',' + mousePos[1] + "<br>" + 'Mouse position: ' + mousePos[2] + ',' + mousePos[3];
	writeMessage(canvas, message, mousePos);