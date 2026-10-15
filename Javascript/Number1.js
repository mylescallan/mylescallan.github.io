function LetUserIntoPage()
{
  var username;
  var password;
  username=this.document.testform.user.value;
  password=this.document.testform.pass.value;
  var pagename=location.href;
// var username = prompt("Please enter your username:", "");
// var password = prompt("Please enter your password:", "");
 
 
 var TheLists = new Array()
 {
  TheLists[0] = "Myles:Splarty";
  TheLists[1] = "Deirdre:Splarty";
  TheLists[2] = "Keith:Hayley";
  TheLists[3] = "Civil:Liberties";
  TheLists[4] = "Roncone:Law";
 }
 for (i = 0; i < TheLists.length; i++)
 { 
  if (TheLists[i].indexOf(username) == 0)
  {
   var TheSplit = TheLists[i].split(":");
   var TheUsername = TheSplit[0];
   var ThePassword = TheSplit[1];
   if (username == TheUsername && password == ThePassword)
   {
	
	if (window.location.href == "http://www.mylescallan.com/Medical.html")
	{ //alert(pagename);
   	window.location.href="http://www.mylescallan.com/Medical/Medical.html";
   	document.getElementById('hiddenpage').style.display = "";
    document.cookie = "access_m=true"
    repeat=false;
    return pagename;
   	break;
    // Your other commands here
    }
    if (window.location.href == "http://www.mylescallan.com/Dental.html")
	{// alert("Welcome, " + username);
   	window.location.href="http://www.mylescallan.com/Medical/Dental.html";
   	document.getElementById('hiddenpage').style.display = "";
    document.cookie = "access_d=true"
    repeat=false;
    return pagename;
   	break;
    // Your other commands here
    }
    if (window.location.href == "http://www.mylescallan.com/Liberties.html")
	{ //alert(pagename);
   	window.location.href="http://www.mylescallan.com/Medical/Liberties.html";
   	document.getElementById('hiddenpage').style.display = "";
    document.cookie = "access_l=true"
    repeat=false;
    return pagename;
   	break;
    // Your other commands here
    }
    if (window.location.href == "http://www.mylescallan.com/All_Dental.html")
	{// alert("Welcome, " + username);
   	window.location.href="http://www.mylescallan.com/Medical/All_Dental.html";
   	document.getElementById('hiddenpage').style.display = "";
    document.cookie = "access_a=true"
    repeat=false;
    return pagename;
   	break;
    // Your other commands here
    }
   }
  }
  if (i == 4)
   {
        alert("Incorrect Login Information");
		window.location.href="http://www.mylescallan.com/Firefox.html";
		repeat=false;
   }
 }
}