var dragonSlaying = function() {
	var slaying = true;
	var youHit = Math.floor(Math.random() * 2);
	var damageThisRound = Math.floor(Math.random() * 5 + 1);
	var totalDamage = 0;

	while (slaying === true) {
		if (youHit === 1) {
			console.log("You Rock!");
			totalDamage += damageThisRound;
			if (totalDamage >= 4) {
				console.log("You Butchered the Dragon, murderer!!");
				slaying = false;
			} else {
				youHit = Math.floor(Math.random() * 2);
			}

		} else {
			console.log("Dimwit!!");
		};
		slaying = false;
	};
}; 