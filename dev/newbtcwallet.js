var bitcoin = require('bitcoin');

var client = new bitcoin.Client({
    host: 'localhost',
    port: 18332,
    user: 'bitcoin',
    pass: 'local321'
});


var fs = require('fs');


client.cmd('getnewaddress', "1", function (err, address) {
    console.log(address)
    var amountToBuy = 10 * 12600;
    client.cmd('sendfrom', "1", address, amountToBuy / Math.pow(10, 8), function (err, txid) {
        console.log(txid)
    });    

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