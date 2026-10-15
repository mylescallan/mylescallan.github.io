function access_a()
{
var strCookie = document.cookie;
var found = false;
var loc1, loc2;
var i = 0;

while(i <= strCookie.length)
{
   loc1 = i;
   loc2 = loc1 + 6;
   if(strCookie.substring(loc1,loc2) == "access_a")
   {
      found = true;
      break;
   }
   i++;
}

if(!found)
{
   document.location = "http://www.mylescallan.com/All_Dental.html";
}
}