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


Event.observe(window, 'load', loadAccordions, false);
	
		//
		//	Set up all accordions
		//
		function loadAccordions() {
			var topAccordion = new accordion('horizontal_container', {
				classNames : {
					toggle : 'horizontal_accordion_toggle',
					toggleActive : 'horizontal_accordion_toggle_active',
					content : 'horizontal_accordion_content'
				},
				defaultSize : {
					width : 525
				},
				direction : 'horizontal'
			});
			
			var bottomAccordion = new accordion('vertical_container');
			
			var nestedVerticalAccordion = new accordion('vertical_nested_container', {
			  classNames : {
					toggle : 'vertical_accordion_toggle',
					toggleActive : 'vertical_accordion_toggle_active',
					content : 'vertical_accordion_content'
				}
			});
			
			// Open first one
			bottomAccordion.activate($$('#vertical_container .accordion_toggle')[0]);
			
			// Open second one
			topAccordion.activate($$('#horizontal_container .horizontal_accordion_toggle')[2]);
		}

var verticalAccordions = $$('.accordion_toggle');
verticalAccordions.each(function(accordion) {
    $(accordion.next(0)).setStyle({
        height: '0px'
    });
});		

// Finish the immediately invoked function expression
 }()); 