/******************************************************
 *                @author Myles
******************************************************/

// Unnecessary

function byId(e) {
	return document.getElementById(e);
}

// NOTE: To Use this file, you need to have ""<body onload='myInit();'>""
//       in your HTML file
function myInit() {
	var dragMe = byId('tgt');
	dragMe.ondragstart = function() {
		return false;
	};
	dragMe.onmousedown = onTgtMouseDown;
}

function onTgtMouseDown(e) {
	var mDlg,
	    self = this;
	var initMx,
	    intMy,
	    initDlgX,
	    initDlgY,
	    dx,
	    dy;
	var mTgt;

	mTgt = this;

	//  mDlg = this.parentNode;
	//  mDlg.zIndex = 1000;
	//  mDlg.style.position = 'absolute';
	mTgt.zIndex = 1000;
	mTgt.style.position = 'absolute';

	e = e || event;
	initMx = e.pageX;
	initMy = e.pageY;
	initDlgX = mTgt.offsetLeft;
	initDlgY = mTgt.offsetTop;
	// offset from top left of element to mouse when button pressed
	dx = initMx - initDlgX;
	dy = initMy - initDlgY;

	document.onmousemove = function(e) {
		e = e || event;
		fixPageXY(e);
		mTgt.style.left = e.pageX - dx + 'px';
		mTgt.style.top = e.pageY - dy + 'px';
	};

	this.onmouseup = function() {
		document.onmousemove = null;
	};
}

// e = event
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
