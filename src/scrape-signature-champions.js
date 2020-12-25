const puppeteer = require('puppeteer');
var fs = require("fs");

(async () => {
  const browser = await puppeteer.launch({headless: true});
  const page = await browser.newPage();
  await page.goto('https://lidepro.cz/podpisovi-sampioni', {waitUntil: 'networkidle2'});

  var huntersTable = await page.evaluate(() => {
    dv = document.getElementsByClassName("data-view");
    console.log(dv[0])
    return dv[0].innerText.replaceAll('\n\t', '\t')
  });

  fs.writeFile('champions.txt', huntersTable, function(err) {
    if (err) {
       return console.error(err);
    }
    console.log("Data written successfully!");
 });


  await page.screenshot({path: 'example.png'});

  await browser.close();
})();
