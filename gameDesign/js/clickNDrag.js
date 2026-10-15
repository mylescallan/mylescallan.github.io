/**
 * @author Myles
 */
function clickNDrag(tgt) {
    "use strict"; // Ensure that all variables are declared

    function fixPageXY(e) {
        if (e.pageX === null && e.clientX !== null) {
            var html = document.documentElement,
                body = document.body;
            e.pageX = e.clientX + (html.scrollLeft || (body && body.scrollLeft) || 0);
            e.pageX -= html.clientLeft || 0;
            e.pageY = e.clientY + (html.scrollTop || (body && body.scrollTop) || 0);
            e.pageY -= html.clientTop || 0;
        }
    }


    document.getElementById(tgt).onmousedown = function() {
        //      document.getElementsByClassName(tgt).onmousedown = function() {

        this.style.position = 'absolute';
        var self = this;

        document.onmousemove = function(e) {
            e = e || event;
            fixPageXY(e);
            self.style.left = e.pageX - 25 + 'px';
            self.style.top = e.pageY - 25 + 'px';
        };

        this.onmouseup = function() {
            document.onmousemove = null;
        };
    };
    document.getElementById(tgt).ondragstart = function() {
        //      document.getElementsByClassName(tgt).ondragstart = function() {
        return false;
    };

}

clickNDrag("tgt0");
clickNDrag("tgt");
clickNDrag('tgt1');
clickNDrag('tgt2');
clickNDrag('tgt3');
clickNDrag('tgt4');
