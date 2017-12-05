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

    client.cmd('getaccountaddress', '1', function(err, myaddress) {
        client.cmd('getbalance', '1', function(err, balance) {
            console.log(myaddress + ": " + balance)
        })
    })

    var amountToBuy = 10 / 10000 * Math.pow(10, 8);
    client.cmd('sendfrom', "1", address, amountToBuy / Math.pow(10, 8), function (err, txid) {
        if (err) console.log(err) 
        else console.log(txid)
    });  
});

  