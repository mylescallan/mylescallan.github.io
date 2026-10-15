function getAllProperties(obj) {
    var properties = '';
    for (property in obj) {
        properties += '\n' + property;
    }
    var output = 'Properties of Object:' + properties;
//    console.log(typeof output);
    return output;
}