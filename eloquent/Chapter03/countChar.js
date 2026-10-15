/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |* Counts the Number of Bs in a string
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

function countChar(string,letter) {
	var i = 0, numChar = 0;
	for (i; i < string.length; i++) {
		if (string.charAt(i) === letter) { // string.charAt(index) returns the letter at the index
			numChar++;
		}
	} return numChar; // return number of occurances of "letter" in "string"
}