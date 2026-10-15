var getReview = function(movie) {
	switch (movie) {
	case "Toy Story 2" :
		return "Great story. Mean prospector."; // Note: because of the "return", no "break;" is required, but should be there
	case "Finding Nemo" :
		return "Cool animation, and funny turtles.";
	case "The Lion King" :
		return "Great songs.";
	default:
		return "I don't know!";
	};

};


getReview("Finding Nemo");



