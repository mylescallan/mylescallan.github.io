/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |*   The Button Event Handler: VERY INSTRUCTIVE (& Wrong)
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

var buttons = document.getElementsByClassName("expand");

var i = 1;
// I start at "1" because there is an extra button that I don't want to attach a handler to.

for (i; i < buttons.length; i++) {// Loop over all but the first button

    // Generate strings associated with the button ids and the event handlers for each button
    var buttonID = "button" + i;
    var clickHandlerID = "clickHandler" + i;

    var buttonEH = document.getElementById(buttonID);
    // Identify the button elements by id

    buttonEH.style.cursor = "pointer";
    // When the mouse hovers over the button element, turn the cursor into a pointing hand

    // As clickHandlerID is a string, to get the browser to recognise it as a function name
    // I use window[clickHandlerID] 
    // NOTE: ... which actually worked, and is the reason that the clickHandler1, etc functions work!!!
    var clickHandler = window[clickHandlerID];
    console.log(clickHandler);

    buttonEH.addEventListener("click", clickHandler, false);
}

function clickHandler1() {
    if (pt1.style.display === 'block') {
        pt1.style.display = 'none';
    } else {
        pt1.style.display = 'block';
    }
}

function clickHandler2() {
    if (pt2.style.display === 'block') {
        pt2.style.display = 'none';
    } else {
        pt2.style.display = 'block';
    }
}
