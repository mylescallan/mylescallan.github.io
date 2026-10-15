
var timeToReveal = 1000;
var timeToActivate = 500;

$(function() {

$('#reveal div').each(function(i) { // Index each div (can be any element incl img) inside the div node with an id of "reveal" (works with <div id='reveal'> ... </div>)

$(this).delay((i++) * timeToActivate).fadeTo(timeToReveal, 1); }); // a) incrementally sets each node to full opacity over timeToReveal milliseconds; 
                                                         // b) The amount of delay before each node appears is determined by its order in the div 
                                                         // multiplied by a constant timeToActivate milliseconds

});

// requires this line of css
// #reveal div {opacity: 0; }

