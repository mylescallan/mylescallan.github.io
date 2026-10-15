//Constructors are a way to make objects with the keyword new. The most basic constructor is the Object constructor, which will make an object with no methods or properties.
// For more complicated objects we can make our own constructors and put in whatever properties and methods we want.


//Our Rabbit constructor defines an adjective property and a describeMyself method.

function Rabbit(adjective) {
    this.adjective = adjective;
    this.describeMyself = function() {
        console.log("I am a " + this.adjective + " rabbit");
    };
}

// now we can easily make all of our rabbits

var rabbit1 = new Rabbit("fluffy");
var rabbit2 = new Rabbit("happy");
var rabbit3 = new Rabbit("sleepy");


// Our person constructor
function Person (name, age) {
    this.name = name;
    this.age = age;
}

// Now we can make an array of people
var family = new Array();
family[0] = new Person("alice", 40);
family[1] = new Person("bob", 42);
family[2] = new Person("michelle", 8);
// add the last family member, "timmy", who is 6 years old
family[3] = new Person("timmy", 6);



// loop through our new array
for (var i = 0; i<family.length; i++){
    console.log(family[i].name);
};

// Our person constructor
function Person (name, age) {
    this.name = name;
    this.age = age;
}

// We can make a function which takes persons as arguments
// This one computes the difference in ages between two people
var ageDifference = function(person1, person2) {
    return person1.age - person2.age;
};

// Make a new function, olderAge, to return the age of
// the older of two people
var olderAge = function(person1, person2) {
    if (person1.age > person2.age){
        return person1.age;
    }else{
        return person2.age;
    };
};

// Let's bring back alice and billy to test our new function
var alice = new Person("Alice", 30);
var billy = new Person("Billy", 25);

console.log("The older person is " + olderAge(alice, billy));

var snoopy = new Object();
snoopy.species = "beagle";
snoopy.age = 10;

// save Snoopy's age and species into variables
// use dot notation for snoopy's species
var species = snoopy.species;
    
// use bracket notation for snoopy's age
var age = snoopy["age"];


// 3 lines required to make harry_potter
var harry_potter = new Object();
harry_potter.pages = 350;
harry_potter.author = "J.K. Rowling";

// A custom constructor for book
function Book (pages, author) {
    this.pages = pages;
    this.author = author;
}

// Use our new constructor to make the_hobbit in one line
var the_hobbit = new Book(320, "J.R.R. Tolkien");


var bob = {
    firstName: "Bob",
    lastName: "Jones",
    phoneNumber: "(650) 777-7777",
    email: "bob.jones@example.com"
};

var mary = {
    firstName: "Mary",
    lastName: "Johnson",
    phoneNumber: "(650) 888-8888",
    email: "mary.johnson@example.com"
};

var contacts = [bob,mary];

console.log(contacts[1].phoneNumber);

var bob = {
    firstName: "Bob",
    lastName: "Jones",
    phoneNumber: "(650) 777-7777",
    email: "bob.jones@example.com"
};

var mary = {
    firstName: "Mary",
    lastName: "Johnson",
    phoneNumber: "(650) 888-8888",
    email: "mary.johnson@example.com"
};

var contacts = [bob, mary];

// printPerson added here

var printPerson = function(person){
    firstName = person.firstName;
    lastName = person.lastName;
    console.log(firstName + " " + lastName);
};

printPerson(contacts[0]);
printPerson(contacts[1]);

var bob = {
    firstName: "Bob",
    lastName: "Jones",
    phoneNumber: "(650) 777-7777",
    email: "bob.jones@example.com"
};

var mary = {
    firstName: "Mary",
    lastName: "Johnson",
    phoneNumber: "(650) 888-8888",
    email: "mary.johnson@example.com"
};

var contacts = [bob, mary];

function printPerson(person) {
    console.log(person.firstName + " " + person.lastName);
}

var list = function() {
    contactsLength = contacts.length;
    for (var i = 0; i < contactsLength; i++){
        printPerson(contacts[i]);
    };
};
list();


var bob = {
    firstName: "Bob",
    lastName: "Jones",
    phoneNumber: "(650) 777-7777",
    email: "bob.jones@example.com"
};

var mary = {
    firstName: "Mary",
    lastName: "Johnson",
    phoneNumber: "(650) 888-8888",
    email: "mary.johnson@example.com"
};

var contacts = [bob, mary];

function printPerson(person) {
    console.log(person.firstName + " " + person.lastName);
}

function list() {
	var contactsLength = contacts.length;
	for (var i = 0; i < contactsLength; i++) {
		printPerson(contacts[i]);
	}
}

/*Create a search function
then call it passing "Jones"*/
var search = function(lastName) {
    contactsLength = contacts.length;
    for (var i = 0; i < contactsLength; i++){
        if (contacts[i].lastName === lastName){
            printPerson(contacts[i]);
        };
    };
};
search("Jones");


// Create a function called add with the parameters firstName, lastName, and email, phoneNumber.
// In this new function, you want to create a new contact object like bob and mary. 
// Instead of having this object's property values be filled with strings though, set them to the appropriate function parameters passed in.


// Add this new contact object to the contacts array.
var bob = {
    firstName: "Bob",
    lastName: "Jones",
    phoneNumber: "(650) 777-7777",
    email: "bob.jones@example.com"
};

var mary = {
    firstName: "Mary",
    lastName: "Johnson",
    phoneNumber: "(650) 888-8888",
    email: "mary.johnson@example.com"
};

var contacts = [bob, mary];

function printPerson(person) {
    console.log(person.firstName + " " + person.lastName);
}

function list() {
	var contactsLength = contacts.length;
	for (var i = 0; i < contactsLength; i++) {
		printPerson(contacts[i]);
	}
}

/*Create a search function
then call it passing "Jones"*/
var search = function(lastName) {
    contactsLength = contacts.length;
    for (var i = 0; i < contactsLength; i++){
        if (contacts[i].lastName === lastName){
            printPerson(contacts[i]);
        };
    };
};

var add = function(firstName, lastName, email, phoneNumber){
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.phoneNumber = phoneNumber;
    contacts[contacts.length] = this; // just guessed this step ... WOW!!!
};

add("Myles","Callan","myles@myles.com","508-994-2840");

list();


// When we call someObj.someMethod(some, values);, the code between the curly brackets { } will run.

var james = {
    job: "programmer",
    married: false,
    speak: function( talk ) {
        console.log("Hello, I am feeling " + talk);
    }
};

james.speak("great");
james.speak("just okay");

//Remember when defining a method for an object, it's easy to reference other properties in that object: just use this.propertyName!
// When that method is called, this.propertyName will always refer to the most recent value of propertyName.
var james = {
    job: "programmer",
    married: false,
    sayJob: function(job) {
        // complete this method
        console.log("Hi, I work as a " + this.job);
    }
};

// james' first job
james.sayJob();

// change james' job to "super programmer" here
james.job="super programmer";

// james' second job
james.sayJob();

// An advantage of bracket notation is that we are not restricted to just using strings in the brackets. We can also use variables whose values are property names:
var james = {
    job: "programmer",
    married: false
};

// set to the first property name of "james"
var aProperty = "job";

// print the value of the first property of "james" 
// using the variable "aProperty"

console.log(james[aProperty]);


// typeof

// complete these definitions so that they will have
// the appropriate types
var anObj = { job: "I'm an object!" };
var aNumber = 42;
var aString = "I'm a string!";

console.log( typeof anObj ); // should print "object"
console.log( typeof aNumber ); // should print "number"
console.log( typeof aString ); // should print "string"

// hasOwnProperty

var myObj = {
    // finish myObj
    name: "myles"
    
};

console.log( myObj.hasOwnProperty('name') ); // should print true
console.log( myObj.hasOwnProperty('nickname') ); // should print false


// loop through an Object

var nyc = {
    fullName: "New York City",
    mayor: "Bill de Blasio",
    population: 8000000,
    boroughs: 5
};

for(var property in nyc) { // NOTE: this loops through the properties, not the values.
  console.log(property);
}


// write a for-in loop to print the value of nyc's properties
for(var property in nyc) { // NOTE: this DOES loop the values. Why use brackets? dog.species = dog["species"], so the dot notation will not work here
  console.log(nyc[property]);
}

// typeof and loop together

var languages = {
    english: "Hello!",
    french: "Bonjour!",
    notALanguage: 4,
    spanish: "Hola!"
};

// print hello in the 3 different languages
for (var em in languages){
    if (typeof languages[em] === 'string'){
        console.log(languages[em]);
    }
}

// When you make a constructor, you are in fact defining a new class. 
// A class can be thought of as a type, or a category of objects—kind of like how Number and String are types in JavaScript.

function Person(name,age) {
  this.name = name;
  this.age = age;
}

// Let's make bob again, using our constructor
var bob = new Person("Bob Smith", 30);
var susan = new Person("Susan Jordan", 35);

// make your own class here
function Circle(radius) {
  this.radius = radius;
}

//  We can add methods to particlar Objects, but that doesn't mean that that Method is added to the constructor/class:
function Dog (breed) {
  this.breed = breed;
}

// here we make buddy and teach him how to bark
var buddy = new Dog("Golden Retriever");
buddy.bark = function() {
  console.log("Woof");
};
buddy.bark();

// Here we have very similar code as last time, but there is an important difference. 
// Instead of using buddy.bark to add the bark method to just the buddy object, we use Dog.prototype.bark which does add the method to the class

function Dog (breed) {
  this.breed = breed;
};

// here we make buddy and teach him how to bark
var buddy = new Dog("golden Retriever");
Dog.prototype.bark = function() {
  console.log("Woof");
};
buddy.bark();

// here we make snoopy
var snoopy = new Dog("Beagle");
/// this time it works!
snoopy.bark();

// Here is another example

// create your Animal class here
function Animal(name,numLegs){
    this.name =name;
    this.numLegs=numLegs;
};

// create the sayName method for Animal

Animal.prototype.sayName=function(){
    console.log("Hi my name is " + this.name);
};

// provided code to test above constructor and method
var penguin = new Animal("Captain Cook", 2);
penguin.sayName();


// INHERITENCE
// the original Animal class and sayName method
function Animal(name, numLegs) {
    this.name = name;
    this.numLegs = numLegs;
}
Animal.prototype.sayName = function() {
    console.log("Hi my name is " + this.name);
};

// define a Penguin class
function Penguin(name) {
    this.name = name;
    this.numLegs=2;
}

// set its prototype to be a new instance of Animal

Penguin.prototype=new Animal(); // This means that the Penguin class inherits all of the properties of the Animal class.

penguin=new Penguin(); // create a new penguin

penguin.sayName(); // NOTE this new penguin has inherited the .sayName() method from the Animal Object.


// Further Examples of the Inheritance chain:

// original classes
function Animal(name, numLegs) {
    this.name = name;
    this.numLegs = numLegs;
    this.isAlive = true;
}
function Penguin(name) {
    this.name = name;
    this.numLegs = 2;
}
function Emperor(name) {
    this.name = name;
    this.saying = "Waddle waddle";
}

// set up the prototype chain
Penguin.prototype = new Animal();
Emperor.prototype = new Penguin();

var myEmperor = new Emperor("Jules");

console.log( myEmperor.saying ); // should print "Waddle waddle"
console.log( myEmperor.numLegs ); // should print 2
console.log(  myEmperor.isAlive ); // should print true

// PUBLIC and PRIVATE Changing this.returnBalance from the last exercise to var returnBalance makes this method private. 
function Person(first,last,age) {
   this.firstname = first;
   this.lastname = last;
   this.age = age;
   var bankBalance = 7500; // NOTE the difference
}

// create your Person 
john = new Person("John","John",23);

// try to print his bankBalance
console.log(john.bankBalance); // RESULT: "undefined"


// This is interesting, as there is no PASS parameter in the definition of the Object

function Person(first,last,age) {
   this.firstname = first;
   this.lastname = last;
   this.age = age;
   var bankBalance = 7500;
  
   this.askTeller = function(pass) {
     if (pass == 1234) return bankBalance;
     else return "Wrong password.";
   };
}

var john = new Person('John','Smith',30);
/* the variable myBalance should access askTeller()
   with a password as an argument  */
myBalance=john.askTeller(1234); // "askTeller()" is a Method of the john Object, which is part of the Person Class. The password is defined within the 
                                // Class but passed through the Method.
                                
                                
// what is this "Object.prototype" anyway...?
var prototypeType = typeof Object.prototype; //object
console.log(prototypeType);

// now let's examine it!
var hasOwn = Object.prototype.hasOwnProperty("hasOwnProperty"); // true
console.log(hasOwn);

// Building a Cash Register

var cashRegister = {
    total:0,
    add: function(itemCost){
        this.total += itemCost;
    }
};


//call the add method for our items

cashRegister.add(0.98);
cashRegister.add(1.23);
cashRegister.add(4.99);
cashRegister.add(0.45);

//Show the total bill
console.log('Your bill is '+cashRegister.total);

var cashRegister = {
    total: 0,
//insert the add method here    
    add: function(itemCost){
        this.total += itemCost;
    },
    scan: function (item) {
        switch (item) { 
        case "eggs": 
            this.add(0.98); 
            break;
        
        case "milk": 
            this.add(1.23); 
            break;

        case "magazine": 
            this.add(4.99); 
            break;

        case "chocolate": 
            this.add(0.45); 
            break;
                        
        //Add other 2 items here
        
        
        }
        return true;
    }
};

//Scan 2 eggs and 3 magazines
cashRegister.scan('eggs');
cashRegister.scan('eggs');
cashRegister.scan('magazine');
cashRegister.scan('magazine');
cashRegister.scan('magazine');

//Show the total bill
console.log('Your bill is '+cashRegister.total);

// Modify the scan method such that if we tell it the quantity of each item, it will be able to add the right amount to the total.

var cashRegister = {
    total:0,
    add: function(itemCost){
        this.total += itemCost;
    },
    scan: function(item,quantity) {
        switch (item) {
        case "eggs": this.add(0.98*quantity); break;
        case "milk": this.add(1.23*quantity); break;
        case "magazine": this.add(4.99*quantity); break;
        case "chocolate": this.add(0.45*quantity); break;
        }
    }
};

// scan each item 4 times

cashRegister.scan('eggs',4);
cashRegister.scan('milk',4);
cashRegister.scan('magazine',4);
cashRegister.scan('chocolate',4);

//Show the total bill
console.log('Your bill is '+cashRegister.total);

// add a voidLastTransaction Method

var cashRegister = {
    total:0,
    //Dont forget to add your property
    add: function(itemCost) {
        this.total +=  itemCost;
        this.lastTransactionAmount = itemCost;
    },
    scan: function(item,quantity) {
        switch (item) {
        case "eggs": this.add(0.98 * quantity); break;
        case "milk": this.add(1.23 * quantity); break;
        case "magazine": this.add(4.99 * quantity); break;
        case "chocolate": this.add(0.45 * quantity); break;
        }
        return true;
    },
    //Add the voidLastTransaction Method here
    voidLastTransaction: function() {
        this.total -= this.lastTransactionAmount;
    }
};

cashRegister.scan('eggs',1);
cashRegister.scan('milk',1);
cashRegister.scan('magazine',1);
cashRegister.scan('chocolate',4);

//Void the last transaction and then add 3 instead
cashRegister.voidLastTransaction();
cashRegister.scan('chocolate',3);



//Show the total bill
console.log('Your bill is '+cashRegister.total);

//Now that we have our objects representing the staff, let's update our cash register to actually apply the discount.
function StaffMember(name,discountPercent){
    this.name = name;
    this.discountPercent = discountPercent;
}

var sally = new StaffMember("Sally",5);
var bob = new StaffMember("Bob",10);

// Create yourself again as 'me' with a staff discount of 20%

var me = new StaffMember("Myles",20);

var cashRegister = {
    total:0,
    lastTransactionAmount: 0,
    add: function(itemCost){
        this.total += (itemCost || 0);
        this.lastTransactionAmount = itemCost;
    },
    scan: function(item,quantity){
        switch (item){
        case "eggs": this.add(0.98 * quantity); break;
        case "milk": this.add(1.23 * quantity); break;
        case "magazine": this.add(4.99 * quantity); break;
        case "chocolate": this.add(0.45 * quantity); break;
        }
        return true;
    },
    voidLastTransaction : function(){
        this.total -= this.lastTransactionAmount;
        this.lastTransactionAmount = 0;
    },
    // Create a new method applyStaffDiscount here
    applyStaffDiscount: function(discountPercent){
        this.total -= this.total*(discountPercent/100);
    }
        
    
};

cashRegister.scan('eggs',1);
cashRegister.scan('milk',1);
cashRegister.scan('magazine',3);
// Apply your staff discount by passing the 'me' object 
// to applyStaffDiscount

cashRegister.applyStaffDiscount(me.discountPercent);
// Show the total bill
console.log('Your bill is '+cashRegister.total.toFixed(2));
