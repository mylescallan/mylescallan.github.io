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
      var collapseDivs, collapseLinks;

      function createDocumentStructure(tagName,index) {
          if (document.getElementsByTagName) {                       // Conditional: Check if method is available to browser
              var elements = document.getElementsByTagName(tagName); // Get 'elements' by tagName
              collapseDivs = new Array(elements.length);             // Create Array
              collapseLinks = new Array(elements.length);            // Create Array
              for (var i = 0; i < elements.length; i++) {            // Loop through tagNames (i.e. 'elements')
                  var element = elements[i];                         // Select each element in elements
                  var siblingContainer;                              // Create Variable 'siblingContainer'
                  if (document.createElement &&                      // Conditional: Check if methods are available to browser
                      (siblingContainer = document.createElement('div')) 
                      && siblingContainer.style) {
                      var siblingNext = element.nextSibling;         // Create Variable (add nextSibling property to 'element')
                      element.parentNode.insertBefore(siblingContainer, siblingNext);   // insertBefore(new, old)
                      var nextElement = elements[i + 1];             // Create Variable nextElement as the next element in elements
                      while (siblingNext != nextElement && siblingNext != null) { // C
                          var toMove = siblingNext;
                          siblingNext = siblingNext.nextSibling;
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
             if (index == 1) {
              createCollapseExpandAll(elements[0]);
              // createCollapseExpandAll(elements[elements.length - 1]);
              }
          }
      }

      function createCollapseLink(element, siblingContainer, index) {     // Creates Collapse Link
          var span;                                                       // Creates Variable 'span' (which is Appended to 'element' (i.e. Tag))
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

      function collapseExpandLink(evt) {
          if (this.collapseDiv.style.display == '') {
              this.parentNode.parentNode.nextSibling.style.display ='none';
              this.firstChild.nodeValue = 'expand';
          } else {
              this.parentNode.parentNode.nextSibling.style.display = '';
              this.firstChild.nodeValue = 'collapse';
          }
          if (evt && evt.preventDefault) {
              evt.preventDefault();
          }
          return false;
      }

      function createCollapseExpandAll(firstElement) {
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

      function expandAll(evt) {
          for (var i = 0; i < collapseDivs.length; i++) {
              collapseDivs[i].style.display = '';
              collapseLinks[i].firstChild.nodeValue = 'collapse';
          }
          if (evt && evt.preventDefault) {
              evt.preventDefault();
          }
          return false;
      }

      function collapseAll(evt) {
          for (var i = 0; i < collapseDivs.length; i++) {
              collapseDivs[i].style.display = 'none';
              collapseLinks[i].firstChild.nodeValue = 'expand';
          }
          if (evt && evt.preventDefault) {
              evt.preventDefault();
          }
          return false;
      }

      var expandtag = ['h2','li'];
      
      window.onload = function(evt) {
      for (var j = 0; j < expandtag.length; j++) {
              createDocumentStructure(expandtag[j],j);
          }
          }
          // Finish the immediately invoked function expression
  }());