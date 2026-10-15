startSession() {
if (isCookiesEnabled() == 0) {
newSession();
} else {
top.document.location.href="enablecookies.html";
}
} 