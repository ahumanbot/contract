var bitcoin = require('bitcoin');
var fs = require('fs');

var client = new bitcoin.Client({
    host: 'localhost',
    port: 18332,
    user: 'bitcoin',
    pass: 'local321'
});





client.cmd('getnewaddress', "1", function (err, address) {
    console.log(address)
    

    fs.writeFile("bitcoin.txt", address, function(err) {
        if(err) {
            return console.log(err);
        }
    }); 

    fs.writeFile("../frontend/public/bitcoin.txt", address, function(err) {
        if(err) {
            return console.log(err);
        }
    }); 
});