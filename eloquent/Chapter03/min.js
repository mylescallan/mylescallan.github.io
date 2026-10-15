/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |* returns the minimum of two parameters
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

function min(num1, num2) {
	if(isNaN(num1) || isNaN(num2)){
		return "This Only Works With Two Numbers";
	}
	if (num1 > num2) {
		return num1;
	} else {
		return num2;
	}
}