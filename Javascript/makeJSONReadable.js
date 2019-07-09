const fs = require('fs');

const bucket = process.argv[2];

fs.readFile('data.json', 'utf8', function(_, data) {
  const parsedData = JSON.parse(data).Contents;

  const fallbackImages = [];
  const placeholders = [];
  const jp2Images = [];
  const webpImages = [];

  for (let i = 0; i < parsedData.length; i++) {
    const url = 'https://' + bucket + '.s3.amazonaws.com/';
    const currentObject = parsedData[i];
    const key = currentObject.Key;
    const indexOfSlash = key.indexOf('/');
    const path = key.slice(0, indexOfSlash);
    const fullUrl = url + key;
    if (path === 'fallback') {
      fallbackImages.push(fullUrl);
    } else if (path === 'placeholders') {
      placeholders.push(fullUrl);
    } else if (path === 'jp2Images') {
      jp2Images.push(fullUrl);
    } else if (path === 'webpImages') {
      webpImages.push(fullUrl);
    }
  }
  const dataBuffer = new Uint8Array(
    Buffer.from(
      JSON.stringify({
        fallbackImages: fallbackImages,
        placeholders: placeholders,
        jp2Images: jp2Images,
        webpImages: webpImages
      })
    )
  );

  fs.writeFile('../imageUrls.json', dataBuffer, function(err) {
    if (err) throw err;
    console.log('The file has been saved! It is stored as imageUrls.json in the home directory.');
  });
});
