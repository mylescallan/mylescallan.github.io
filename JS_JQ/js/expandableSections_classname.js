  /***************************************************************************************
           The Script Is Placed Inside An Immediately Invoked Function Expression
                       Which Helps Protect The Scope Of Variables:
           1. Enable Expandable Sections of a Webpage
           2. Is Used in JS_JQ/Loaded_Expandable.shtml
  ***************************************************************************************/

 (function() { // Immediately Invoked Function to start script 



  /***************************************************************************************
  // Part Two: Generate Collapsable divs based on tag (last line to change referenced tag
  ***************************************************************************************/


var collapseDivs, collapseLinks;

function createDocumentStructure (tagName, className) {

  if (document.getElementsByTagName) {
    var elements = document.getElementsByTagName(tagName); // Get 'elements' by Tagname
       if(className){
          elements.className = className;
       }
    collapseDivs = new Array(elements.length);             // Create Array
    collapseLinks = new Array(elements.length);            // Create Array
    for (var i = 0; i < elements.length; i++) {            // Loop through Tagnames (i.e. 'elements')
      var element = elements[i];                           // Select each element
      var siblingContainer;                                // Create Variable 'siblingContainer'
      if (document.createElement &&                        // Conditional ??
          (siblingContainer = document.createElement('div')) &&
          siblingContainer.style) 
      {
        var nextSibling = element.nextSibling;             // Create Variable (nextSibling to 'element')
        element.parentNode.insertBefore(siblingContainer, nextSibling);
        var nextElement = elements[i + 1];
        while (nextSibling != nextElement && nextSibling != null) {
          var toMove = nextSibling;
          nextSibling = nextSibling.nextSibling;
          siblingContainer.appendChild(toMove);
        }
        siblingContainer.style.display = 'none';
        
        collapseDivs[i] = siblingContainer;
        
        createCollapseLink(element, siblingContainer, i);
      }
      else {
        // no dynamic creation of elements possible
        return;
      }
    }
      createCollapseExpandAll(elements[0]);
      createCollapseExpandAll(elements[elements.length - 1]);
    }
}

function createCollapseLink (element, siblingContainer, index) {
  var span;
  if (document.createElement && (span = document.createElement('span'))) {
    span.appendChild(document.createTextNode(String.fromCharCode(160)));
    var link = document.createElement('a');
    link.collapseDiv = siblingContainer;
    link.href = '#';
    link.appendChild(document.createTextNode('expand'));
    link.onclick = collapseExpandLink;
    collapseLinks[index] = link;
    span.appendChild(link);
    element.appendChild(span);
  }
}

function collapseExpandLink (evt) {
  if (this.collapseDiv.style.display == '') {
    this.parentNode.parentNode.nextSibling.style.display = 'none';
    this.firstChild.nodeValue = 'expand';
  }
  else {
    this.parentNode.parentNode.nextSibling.style.display = '';
    this.firstChild.nodeValue = 'collapse';
  }

  if (evt && evt.preventDefault) {
    evt.preventDefault();
  }
  return false;
}

function createCollapseExpandAll (firstElement) {
  var div;
  if (document.createElement && (div = document.createElement('div'))) {
    var link = document.createElement('a');
    link.href = '#';
    link.appendChild(document.createTextNode('Expand All'));
    link.onclick = expandAll;
    div.appendChild(link);
    div.appendChild(document.createTextNode(' '));
    link = document.createElement('a');
    link.href = '#';
    link.appendChild(document.createTextNode('Collapse All'));
    link.onclick = collapseAll;
    div.appendChild(link);
    firstElement.parentNode.insertBefore(div, firstElement);
  }
}

function expandAll (evt) {
  for (var i = 0; i < collapseDivs.length; i++) {
    collapseDivs[i].style.display = '';
    collapseLinks[i].firstChild.nodeValue = 'collapse';
  }
  
  if (evt && evt.preventDefault) {
    evt.preventDefault();
  }
  return false;
}

function collapseAll (evt) {
  for (var i = 0; i < collapseDivs.length; i++) {
    collapseDivs[i].style.display = 'none';
    collapseLinks[i].firstChild.nodeValue = 'expand';
  }
  
  if (evt && evt.preventDefault) {
    evt.preventDefault();
  }
  return false;
}

window.onload = function (evt) {
  createDocumentStructure('li', 'cool');
//  createDocumentStructure('h2');
}

// Finish the immediately invoked function expression
 }()); 