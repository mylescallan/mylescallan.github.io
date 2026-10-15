var start = new Date().getTime();
function Parent() { this.delta = 10; };

function ChildA(){};
ChildA.prototype = new Parent();
function ChildB(){}
ChildB.prototype = new ChildA();
function ChildC(){}
ChildC.prototype = new ChildB();
function ChildD(){};
ChildD.prototype = new ChildC();
function ChildE(){};
ChildE.prototype = new ChildD();

function nestedFn() {
  var child = new ChildE();
  var counter = 0;
  for(var i = 0; i < 1000; i++) {
    for(var j = 0; j < 1000; j++) {
      for(var k = 0; k < 1000; k++) {
        counter += child.delta;
      }
    }
  }
  console.log('Final result: ' + counter);
}

nestedFn();
var end = new Date().getTime();
var diff = end - start;
console.log('Total time: ' + diff + ' milliseconds');

var start0 = new Date().getTime();
function nestedFn0() {
  var child = new ChildE();
  var counter = 0;
  var delta = child.delta;  // cache child.delta value in current scope
  for(var i = 0; i < 1000; i++) {
    for(var j = 0; j < 1000; j++) {
      for(var k = 0; k < 1000; k++) {
        counter += delta;  // no inheritance tree traversal needed!
      }
    }
  }
  console.log('Final result: ' + counter);
}

nestedFn0();
var end0 = new Date().getTime();
var diff0 = end0 - start0;
console.log('Total time: ' + diff0 + ' milliseconds');

var diffTotal = diff - diff0;

console.log('Total time: ' + diffTotal + ' milliseconds');