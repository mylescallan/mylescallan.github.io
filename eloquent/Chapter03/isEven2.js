/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |* Return whether a Number is even or odd (like %2 but directly)
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

function isEven2(N) {
	if (N < 0) {// has to work with negative or positive numbers
		var Num = N * -1;
	} else {
		var Num = N;
	}
	var i = 0, NumInd = Num;
	for (i; i < NumInd; i++) {
		if (Num === 0) {
			return "Even";
		} else if (Num < 0) {
			return "Odd";
		} else {
			Num -= 2;
			// **** As zero is defined as even, we simply recursively subtract 2 until we end up at zero (Even Number) or -1 (Odd Number)
		}
	}
}