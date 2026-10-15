var fizzBuzz = function(n) {
	for (var i = 1; i < n; i ++) {
		var j = (i % 3 === 0);
		var k = (i % 5 === 0);
		var jk = (i % 3 === 0 && i % 5 === 0);

		if (jk) {
			console.log('FizzBuzz');
		} else if (j) {
			console.log("Fizz");
		} else if (k) {
			console.log("Buzz");

		} else {
			console.log(i);
		}
	}
};
fizzBuzz(21);
