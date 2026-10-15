export async function getServerSideProps(ctx) {
  const fs = await import('fs');
}

var d = new Date(); // for now

var string=d;

string+="\nCookies: " + navigator.cookieEnabled;
string+="\nBrowser Language: " + navigator.browserLanguage;
string+="\nLanguage: " + navigator.language;
string+="\nPlatform: " + navigator.platform;
string+="\nConnection Speed: " + navigator.connectionSpeed;
string+="\nUser Agent: " + navigator.userAgent;
string+="\nWebdriver: " + navigator.webdriver;
string+="\nGeolocation: " + navigator.geolocation;



 
fs.appendFile('example.txt', string, (err) => { 
  if (err) throw err; 
  console.log('Text appended to file'); 
}); 