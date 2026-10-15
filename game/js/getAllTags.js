/* ------------------------------------------------------------ *\
|* ------------------------------------------------------------ *|
|*  Returns a (string) list of elements of an Array
|* ------------------------------------------------------------ *|
\* ------------------------------------------------------------ */

// Used with var all = document.getElementsByTagName("*");
// on game/overview.html with a drop-down list
function getAllTags(all) {
    var tags0 = "";
    var index = 0;

    for (index; index < all.length; index++) {
        tags0 += ' <br> ' + all[index];
    }

    var output = '"Tags" in Page:' + tags0;
    //    console.log(typeof output);
    return output;
}

