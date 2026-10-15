var nodeList = document.getElementsByClassName('draggable');

var isTouchDevice = 'ontouchstart' in window || navigator.msMaxTouchPoints;

if (isTouchDevice) {
	for (var i = 0; i < nodeList.length; i++) {
		var obj = nodeList[i];
		obj.addEventListener('touchmove', function(event) {
			var touch = event.targetTouches[0];

			// Place element where the finger is
			event.target.style.left = touch.pageX + 'px';
			event.target.style.top = touch.pageY + 'px';
			event.preventDefault();
		}, false);
	}
} else {

	for (var i = 0; i < nodeList.length; i++) {
		var obj = nodeList[i];
		obj.addEventListener('mousemove', function(event) {
			fixPageXY(event);

			// Place element where the finger is
			event.target.style.left = event.pageX + 'px';
			event.target.style.top = event.pageY + 'px';
			event.preventDefault();
		}, false);
	}
}

function fixPageXY(e) {
	if (e.pageX == null && e.clientX != null) {
		var html = document.documentElement;
		var body = document.body;
		e.pageX = e.clientX + (html.scrollLeft || body && body.scrollLeft || 0);
		e.pageX -= html.clientLeft || 0;
		e.pageY = e.clientY + (html.scrollTop || body && body.scrollTop || 0);
		e.pageY -= html.clientTop || 0;
	};
}