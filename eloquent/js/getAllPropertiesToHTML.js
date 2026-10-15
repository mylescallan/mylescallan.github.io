/* ------------------------------------------------------------ *\
|* ------------------------------------------------------------ *|
|*  Returns a (string) list of the properties of an Object
|* ------------------------------------------------------------ *|
\* ------------------------------------------------------------ */

// on game/overview.html & game/JSFunctions.html with a drop-down list

function getAllPropertiesToHTML(obj) {
    var properties = '';
    for (property in obj) {
        properties += ' <br> ' + property;
    }
    var output = 'Properties of Object:' + properties;
    //    console.log(typeof output);
    return output;
}

