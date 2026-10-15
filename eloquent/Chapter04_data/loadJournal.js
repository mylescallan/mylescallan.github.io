/* ------------------------------------------------------------ *\
 |* ------------------------------------------------------------ *|
 |* This is a workaround to get the program to load the Journal  *|
 |* and run the scripts.
 |* ------------------------------------------------------------ *|
 \* ------------------------------------------------------------ */

/* indexOf is an array method, that returns the index of a property if it exists in the array */
/* if it does not exist in the array, indexOf returns -1                                       */
function hasEvent(event, entry) {
    return entry.events.indexOf(event) != -1;
    // returns a boolean, if event exists, i.e. if indexOf != -1, returns true, else, returns false
}

/* counts the occurances of (not)Event and (not)squirrel and saves the values in a 1x4 array */
function tableFor(event, journal) {
    var table = [0, 0, 0, 0];
    // 4 alternatives, in order: [(no event, no squirrel), (event, no squirrel), (no event, squirrel), (event, squirrel)]
    var i = 0;
    for (i; i < journal.length; i++) {// loop through the journal, which is an array containing objects [{events:[],squirrel:boolean}]
        var entry = journal[i],
            index = 0;
        if (hasEvent(event, entry)) {// if event, move to index 1 of table array
            index += 1;
        }
        if (entry.squirrel) {// if squirrel, move to index 3 of table array
            index += 2;
        }
        table[index] += 1;
        // add 1 to the value of the table index
    }
    return table;
}

/* from the table array, calculate correlation */
function phi(table) {
    return (table[3] * table[0] - table[2] * table[1]) / Math.sqrt((table[2] + table[3]) * (table[0] + table[1]) * (table[1] + table[3]) * (table[0] + table[2]));
}

/* store correlations in an object, as a map */
function gatherCorrelations(journal) {
    var phis = {},
        entry = 0;
    for (entry; entry < journal.length; entry++) {
        var events = journal[entry].events,
            i = 0;
        for (i; i < events.length; i++) {
            var event = events[i];
            if (!(event in phis)) {
                phis[event] = phi(tableFor(event, journal));
            }
        }
    }
    return phis;
}

