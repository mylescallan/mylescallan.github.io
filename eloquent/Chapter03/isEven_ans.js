function isEven(n) {
	if (n == 0)
		return true;
	else if (n == 1)
		return false;
	else if (n < 0)
		return isEven(-n);
	else
		return isEven(n - 2);
}
console.log(isEven(50));
// → trueconsole.log(isEven(75));// → falseconsole.log(isEven(-1));// → false