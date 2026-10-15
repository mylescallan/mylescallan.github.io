  /***************************************************************************************
           The Script Is Placed Inside An Immediately Invoked Function Expression
                       Which Helps Protect The Scope Of Variables:
           1. Enable Expandable Sections of a Webpage
           2. Is Used in JS_JQ/Loaded_Expandable.shtml
  ***************************************************************************************/
  (function() { // Immediately Invoked Function to start script 
      /***************************************************************************************
  Part Two: Generate Collapsable divs based on tag (last line to change referenced tag
***************************************************************************************/
      var expandtag = ['li', 'h2'];
      // alert(expandtag[0]); 
      var collapseDivs = [];
      var collapseLinks = [];
      var elements = [];
      var siblingContainer = [];
      var siblingNext = [];
      var nextElement = [];
      var toMove = [];
      var element = [];
      
      

          function createDocumentStructure(tagName, collapseDivs, collapseLinks, elements, element, siblingContainer, nextSibling, nextElement, toMove, index) {
              if (document.getElementsByTagName) {
                  elements[j] = document.getElementsByTagName(tagName);
                  collapseDivs[j] = new Array(elements[j].length);
                  collapseLinks[j] = new Array(elements[j].length);
                  for (var i = 0; i < elements[j].length; i++) {
                      element[j] = elements[j][i];
                      if (document.createElement && (siblingContainer[j] = document.createElement('div')) && siblingContainer[j].style) {
                          siblingNext[j] = element[j].nextSibling;
                          element[j].parentNode.insertBefore(siblingContainer[j], siblingNext[j]);
                          nextElement[j] = elements[j][i + 1];
                          while (siblingNext[j] != nextElement[j] && siblingNext[j] !== null) {
                              toMove[j] = siblingNext[j];
                              siblingNext[j] = siblingNext[j].nextSibling;
                              siblingContainer[j].appendChild(toMove);
                          }
                          siblingContainer[j].style.display = 'none';
                          collapseDivs[j][i] = siblingContainer[j];
                          createCollapseLink(element[j], siblingContainer[j], i);
                      } 
                      else {
                          // no dynamic creation of elements possible
                          alert(expandtag[0]);
                          return;
                      }
                  }
                  if (j < 1) {
                      createCollapseExpandAll(elements[j][0]);
                  }
              }
          }
 

      function createCollapseLink(element, siblingContainer, index) {
          var span;
          if (document.createElement && (span = document.createElement('span'))) {
              span.appendChild(document.createTextNode(String.fromCharCode(160)));
              var link = document.createElement('a');
              link.collapseDiv = siblingContainer[j];
              link.href = '#';
              link.appendChild(document.createTextNode('expand'));
              link.onclick = collapseExpandLink;
              collapseLinks[j][index] = link;
              span.appendChild(link);
              element[j].appendChild(span);
          }
      }

      function collapseExpandLink(evt) {
          if (this.collapseDiv[j].style.display == '') {
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
          for (var i = 0; i < collapseDivs[j].length; i++) {
              collapseDivs[j][i].style.display = '';
              collapseLinks[j][i].firstChild.nodeValue = 'collapse';
          }
          if (evt && evt.preventDefault) {
              evt.preventDefault();
          }
          return false;
      }

      function collapseAll(evt) {
          for (var i = 0; i < collapseDivs[j].length; i++) {
              collapseDivs[j][i].style.display = 'none';
              collapseLinks[j][i].firstChild.nodeValue = 'expand';
          }
          if (evt && evt.preventDefault) {
              evt.preventDefault();
          }
          return false;
      }

      window.onload = function(evt) {
            for (var j = 0; j < expandtag.length; j++) {
              createDocumentStructure(expandtag[j], collapseDivs, collapseLinks, elements, element, siblingContainer, nextSibling, nextElement, toMove, j);
              //  createDocumentStructure('h2');
              }
          }
          // Finish the immediately invoked function expression
  }());