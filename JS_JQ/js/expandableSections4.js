  /***************************************************************************************
           The Script Is Placed Inside An Immediately Invoked Function Expression
                       Which Helps Protect The Scope Of Variables:
           1. Enable Expandable Sections of a Webpage
           2. Is Used in ch03/expandableSections.html
  ***************************************************************************************/

 // (function() { // Immediately Invoked Function to start script 

  /***************************************************************************************
  // Part One: Create Hotel Object And Write Out The Offer Details - Using All Three Ways of Creating an Object
  // To Test Each, Uncomment the Relevant Object Method
  ***************************************************************************************/


window.onload = function () {
    var mylist = document.getElementById('mylist');
    var clickers = mylist.getElementsByTagName('a');
    var paras = mylist.getElementsByTagName('div');
    for (var i = 1;i < paras.length;i++) {
        paras[i].style.display = "none";
    }
    for (var i = 0;i <clickers.length;i++) {
        clickers[i].style.display = "inline";
        clickers[i].onclick = function () {
            if (this.parentNode.nextSibling.style.display == "none") {
                this.parentNode.nextSibling.style.display = "block";
                this.firstChild.nodeValue = "close this section";
            } else {
                this.parentNode.nextSibling.style.display = "none";
                this.firstChild.nodeValue = "open this section";
            }
        }
    }
}

// Finish the immediately invoked function expression
//  }()); 