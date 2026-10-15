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
    evt.stopPropagation(); // Can use either this or return false, a little hover kill here.
    return false;
}

function makeClickHandler(evt) {
    "use strict";
    divMouse.style.color = '#DAA520';
    divMouse.innerHTML = "<em>Mouseout Now<em>: Okay, you've seen it";
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
