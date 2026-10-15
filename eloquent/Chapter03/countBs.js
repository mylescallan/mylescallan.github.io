/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |* Counts the Number of Bs in a string
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

function countBs(string) {
	var i = 0, numB = 0;
	for (i; i < string.length; i++) {
		if (string.charAt(i) === "B") { // string.charAt(index) returns the letter at the index
			numB++;
		}
	}	return numB;
}