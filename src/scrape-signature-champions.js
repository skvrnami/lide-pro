const puppeteer = require('puppeteer');
var fs = require("fs");

(async () => {
  const browser = await puppeteer.launch({headless: true});
  const page = await browser.newPage();
  await page.goto('https://lidepro.cz/podpisovi-sampioni', {waitUntil: 'networkidle2'});

  var huntersTable = await page.evaluate(() => {
    var d = new Date();
    var timestamp = d.toISOString();
    dv = document.getElementsByClassName("data-view");
    text = dv[0].childNodes[3].innerText + '\n\n';
    return text.replaceAll('\n\t', '\t')
        .replaceAll('\n\n', '\t' + timestamp + '\n')
        .replaceAll('\t', ';')
  });

  fs.appendFile('output/champions.csv', huntersTable, function(err) {
    if (err) {
       return console.error(err);
    }
    console.log("Data written successfully!");
 });

  await browser.close();
})();
