var bitcoin = require('bitcoin');
var fs = require('fs');

var client = new bitcoin.Client({
    host: 'localhost',
    port: 18332,
    user: 'bitcoin',
    pass: 'local321'
});


fs.readFile('../frontend/public/bitcoin.txt', 'utf8', function (err, address) {
    if (err) {
        return console.log(err);
    }

    client.cmd('getbalance', '1', function(err, balance) {
        console.log(address + ": " + balance)
    })

    /*
    var amountToBuy = 10 * 12600;
    client.cmd('sendfrom', "1", address, amountToBuy / Math.pow(10, 8), function (err, txid) {
        console.log(txid)
    });  
    */
});

  