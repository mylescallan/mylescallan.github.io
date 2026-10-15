/*	$('#reveal div').hide();
 $('h3').mouseenter(function() {
 // `this` is the DOM element that was clicked
 $('h3').index(this).slideToggle("slow");
 });
 */

jQuery(document).ready(function($) {
	//Set default open/close settings
	$('.activeDiv .hidden').hide();
	//Hide/close all containers

	//On Click
	$('h3').mouseover(function() {
		$(this).index('div').slideToggle("slow");
		return false;
		//Prevent the browser jump to the link anchor

	});
});
