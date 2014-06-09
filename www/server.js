#!/usr/bin/env node

var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World ' + new Date().getTime() + '\n');
}).listen(8000);
console.log('Server running');
