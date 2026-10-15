/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*   The Event Handler For Background Change
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */
var toggle = false;
var divMouse0 = document.getElementById('divBack0');

function makeClickHandler0() {
    "use strict";
    if (toggle) {
        divMouse0.style.color = 'black';
        divMouse0.innerHTML = '<em>Click Here:</em> To see what you can do with Javascript';
        divMouse0.style.opacity = "1";
        document.getElementById('bodyBack').setAttribute("class", 'nowHidden');
        toggle = !toggle;
        return false;
    } else {
        divMouse0.style.color = '#DAA520';
        divMouse0.innerHTML = "<em>Click Again</em>: Okay, you've seen it";
        divMouse0.style.opacity = "0.6";
        document.getElementById('bodyBack').setAttribute("class", 'unHidden0');
        toggle = !toggle;
    }
    return false;
    // NOTE: Change innerHTML
}

divMouse0.addEventListener("click", makeClickHandler0, false);

/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*   The mouseenter Event Handler
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */
var toggle = false;
var divMouse = document.getElementById('divBack');

function makeClickHandler1(evt) {
    "use strict";
    divMouse.style.color = 'black';
    divMouse.innerHTML = '<em>Mouseover Here:</em> To see what you can do with Javascript';
    divMouse.style.opacity = "1";

    document.getElementById('bodyBack').setAttribute("class", 'nowHidden');
    evt.stopPropagation();
    // Can use either this or return false, a little hover kill here.
    return false;
}

function makeClickHandler(evt) {
    "use strict";
    divMouse.style.color = '#DAA520';
    divMouse.innerHTML = "<em>Mouseout Now</em>: Okay, you've seen it";
    divMouse.style.opacity = "0.6";

    document.getElementById('bodyBack').setAttribute("class", 'unHidden');
    evt.stopPropagation();
    return false;
}

// NOTE: Change innerHTML}
divMouse.addEventListener("mouseenter", makeClickHandler, false);
// NOTE: All earlier versions of this had mouseover and mouseout - they respond to mouse events
divMouse.addEventListener("mouseleave", makeClickHandler1, false);
// that affect the parent node, which gives an unstable appearance (as you are mouseout-ing the parent)

/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*   clickNDrag.js see ../js/ folder
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

function clickNDrag(tgt) {
    "use strict"; // Ensure that all variables are declared

    function fixPageXY(e) {
        if (e.pageX === null && e.clientX !== null) {
            var html = document.documentElement,
                body = document.body;
            e.pageX = e.clientX + (html.scrollLeft || (body && body.scrollLeft) || 0);
            e.pageX -= html.clientLeft || 0;
            e.pageY = e.clientY + (html.scrollTop || (body && body.scrollTop) || 0);
            e.pageY -= html.clientTop || 0;
        }
    }


    document.getElementById(tgt).onmousedown = function() {
        //      document.getElementsByClassName(tgt).onmousedown = function() {

        this.style.position = 'absolute';
        var self = this;

        document.onmousemove = function(e) {
            e = e || event;
            fixPageXY(e);
            self.style.left = e.pageX - 25 + 'px';
            self.style.top = e.pageY - 25 + 'px';
        };

        this.onmouseup = function() {
            document.onmousemove = null;
        };
    };
    document.getElementById(tgt).ondragstart = function() {
        //      document.getElementsByClassName(tgt).ondragstart = function() {
        return false;
    };

}

clickNDrag("tgt0");
 /* clickNDrag("divOuter1");
 clickNDrag('tgt1');

 clickNDrag('tgt2');
 clickNDrag('tgt3');
 clickNDrag('tgt4'); */
