// Set a cookie
function setCookie(name, value, expires, path, domain, secure) {
// set time, it's in milliseconds
var today = new Date();
today.setTime(today.getTime());

if (expires) {
expires = expires * 1000 * 60;
}
var expires_date = new Date(today.getTime() + (expires));
document.cookie = name + "=" + escape(value) +
((expires) ? ";expires=" + expires_date.toGMTString() : "") +
((path) ? ";path=" + path : "") +
((domain) ? ";domain=" + domain : "") +
((secure) ? ";secure" : "");
}

// Get the specified cookie
function getCookie(name) {

var dc = document.cookie;
var start = dc.indexOf(name + "=");
var len = start + name.length + 1;

if ((!start) &&
(name != dc.substring(0, name.length))) {
return null;
}

if (start == -1) return null;
var end = dc.indexOf( ";", len );
if (end == -1) end = dc.length;
return unescape(dc.substring(len, end));
}

// Indicate that user visited the logon page.
function newSession() {
setCookie("visitedloginscreen", "yes", "", "/", "", "");
}

// Indicate that the password entered is valid.
function passwordValidated() {
setCookie("passwordisvalid", "yes", "", "/", "", "");
}

// Check whether user visited logon page.
function checkSession() {
if (getCookie("visitedloginscreen") != "yes") {
top.location.href="illegalaccess.html";
}
}

// Check whether user entered valid password.
function checkValidation() {
if (getCookie("passwordisvalid") != "yes") {
top.location.href="illegalaccess.html";
}
}

// Check if cookies are enabled on client browser.
function isCookiesEnabled() {
setCookie("cookiesenabled", "yes", "", "/", "", "");
if (getCookie("cookiesenabled") != "yes") {
return -1;
} else {
return 0;
}
}
