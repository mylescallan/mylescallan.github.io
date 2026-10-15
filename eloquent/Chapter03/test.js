function countChar(string, ch) {
	var counted = 0;
	for (var i = 0; i < string.length; i++)
		if (string.charAt(i) == ch)
			counted += 1;
	return counted;
}

function countBs(string) {
	return countChar(string, "B");
}
console.log(countBs("BBC"));
// → 2console.log(countChar("kakkerlak", "k"));// → 4




function test1(){
    var n1 = 0;
    return function test2(i){
        for (i; i<n; i++){
            n1+=i;
            
        }return n1;
    }
}
