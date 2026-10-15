var friends = {};

friends.bill = {
	firstName : "Bill",
	lastName : "O'Reilly",
	number : '508-114-5522',
	address : ['1 Up His Own Ass', 'Faux Noise', 'BS', '66666'],
	age : 343,
	wage : 234323434523
};

friends.steve = {
	firstName : "Steve",
	lastName : "Jobs",
	number : '508-314-5522',
	address : ['1 Guru Street', 'Heaven', 'AA', '11111'],
	age : 3423,
	wage : 234323423434523
};

friends.deirdre = {
	firstName : "Deirdre",
	lastName : "Ni Chonaill",
	number : '508-114-4179',
	address : ['4 Oak Street', 'Grafton', 'MA', '01519'],
	age : 46,
	wage : 2343234234334523
};

friends.myles = {
	firstName : "Myles",
	lastName : "Callan",
	number : '508-414-5522',
	address : ['5 W Main Street', 'Westborough', 'MA', '01581'],
	age : 47,
	wage : 22342334334323434523
};

var list = function(obj) {
	for (var xx in obj) {
		console.log(xx);
	};
};

var search = function(name) {
	for (var key in friends) {
		var obj = friends[key];
		if (obj.firstName === name) {
		    console.log(obj);
		    return obj;
		    };
	};
};

search('Deirdre');

