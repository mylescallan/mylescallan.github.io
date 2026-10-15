var c;
var k=0;
var j=0;
var ary=[];
var divs=document.getElementsByTagName('div');
var lnks=document.getElementsByTagName('a');
var splt;

function showDiv(num) {
for(c=0;c<j;c++){
document.getElementById('a'+c).firstChild.nodeValue='show';
document.getElementById('a'+num).firstChild.nodeValue='hide';
ary[c]=true;
ary[num]=false;
}
for(c=0;c<divs.length;c++) {
if(divs[c].className=='show') {
divs[c].className='hide';
}
}
document.getElementById('d'+num).className='show';
}