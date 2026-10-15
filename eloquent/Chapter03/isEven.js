 /* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |* Return whether a Number is even or odd (like %2 but directly)
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */


function isEven(N) {
	if (N < 0) { // has to work with negative or positive numbers
		var Num = N * -1;
	} else {
		var Num = N;
	}
	function isEven2(Num) {
		if (Num === 0) {
			return "Even";
		} else if (Num < 0) {
			return "Odd";
		} else {
			Num -= 2; // **** As zero is defined as even, we simply recursively subtract 2 until we end up at zero (Even Number) or -1 (Odd Number)
			return isEven2(Num);
		}
	} return isEven2(Num); // NOTE: required for the main function to return the outcome of the subroutine.
};