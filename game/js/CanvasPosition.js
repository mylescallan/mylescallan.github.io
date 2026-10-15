      function writeMessage(canvas, message, mousePos) {
        var context = canvas.getContext('2d');
        context.clearRect(0, 0, canvas.width, canvas.height);
        context.font = '18pt Calibri';
        context.fillStyle = 'black';
        context.fillText(message, mousePos.x, mousePos.y);
      }
      function getMousePos(canvas, evt) {
        var rect = canvas.getBoundingClientRect();
        return {
          a: Math.round(evt.clientX),
          b: Math.round(evt.clientY),
          x: Math.round(evt.clientX - rect.left),
          y: Math.round(evt.clientY - rect.top)
        };
      }
      var canvas = document.getElementById('myCanvas3');
      var context = canvas.getContext('2d');

      canvas.addEventListener('mousemove', function(evt) {
        var mousePos = getMousePos(canvas, evt);
        var message = 'Canvas Mouse position: ' + mousePos.x + ',' + mousePos.y + "\n" + '-- Mouse position: ' + mousePos.a + ',' + mousePos.b;
//        writeMessage(canvas, message, mousePos);
          writeMessage(canvas, message, {x :4, y : 18});
      }, false);