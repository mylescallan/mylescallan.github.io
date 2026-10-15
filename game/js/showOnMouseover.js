$(document).ready(function() {
	$("article").hide();
	$("h3").mouseover(function() {
		$(this).nextAll("article:first").stop().slideDown("slow");
	});
	//	$("h3").mouseout(function() {
	//				$(this).children('.hiddenDiv').slideUp("slow");
	//	});
});
