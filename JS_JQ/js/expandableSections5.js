  /***************************************************************************************
           The Script Is Placed Inside An Immediately Invoked Function Expression
                       Which Helps Protect The Scope Of Variables:
           1. Enable Expandable Sections of a Webpage
           2. Is Used in ch03/expandableSections.html
  ***************************************************************************************/

(function() { // Immediately Invoked Function to start script 

  /***************************************************************************************
  // Part One: Create Hotel Object And Write Out The Offer Details - Using All Three Ways of Creating an Object
  // To Test Each, Uncomment the Relevant Object Method
  ***************************************************************************************/


function showHideDiv(linkObj, divID)
{
    var showDiv = (linkObj.innerHTML!='Hide div.');
    document.getElementById(divID).style.display = (showDiv) ? 'block' : 'none';
    linkObj.innerHTML = (showDiv) ? 'Hide div.' : 'Show div.';
    return;
}

// Finish the immediately invoked function expression
  }()); 