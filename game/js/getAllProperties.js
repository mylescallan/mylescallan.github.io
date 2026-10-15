function getAllProperties(obj) {
  var properties = '';
  for (property in obj) {
    properties += '\n' + property;
  }
  console.log('Properties of object:' + properties);
}