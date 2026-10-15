function measureJSLoopSpeed() {
    "use strict";
    var output = "",
        count = 0;
    function addOne() {
        count = count + 1;
    }

    // Date.now() returns a big number representing the number of
    // milliseconds that have elapsed since Jan 01 1970
    var now = Date.now();

    // Loop until Date.now() is 1000 milliseconds (1 second) or more into
    // the future from when we started looping. On each loop, call addOne
    while (Date.now() - now < 1000)addOne();

    // Finally it has been >= 1000ms, so let's print out our total count
    output = "In 1 second, your Javascript interpreter has performed " + count + " tasks";

    return output;
}

