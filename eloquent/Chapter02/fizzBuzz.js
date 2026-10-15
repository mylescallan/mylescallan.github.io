var text = 'Myles They are not even Myles trying to hide their Myles racism any more Myles They are not even Myles trying to hide their Myles Myles They are not even Myles trying to hide their Myles';
var myName = 'Myles';
var hits = [];

for (var i = 0; i < text.length; i++) {
	if (text[i] === myName[0]) {
		var newName = "";

		for (var j = i; j < i + myName.length; j++) {
			newName += text[j];
		};
		hits.push(newName);
	};

};

for (var i = 0; i < hits.length; i++) {
	console.log(hits[i]);
};

console.log(hits.length); 