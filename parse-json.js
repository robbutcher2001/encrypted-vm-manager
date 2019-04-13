'use strict';

let output = 'Not assigned';

if (process.argv.length === 4) {
  const b64 = process.argv[2];
  const key = process.argv[3];
  const json = JSON.parse(new Buffer(b64, 'base64').toString('UTF-8'));

  output = json[key];
}

console.log(output);
