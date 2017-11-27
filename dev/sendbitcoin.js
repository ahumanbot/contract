var bitcoin = require('bitcoin');

var client = new bitcoin.Client({
    host: 'localhost',
    port: 18332,
    user: 'bitcoin',
    pass: 'local321'
});


var amountToBuy = 10 * 12600;
client.cmd('sendfrom', "1", "moMMc8vYx7VNq9zCpiV41JpdNfiXRNJDiV", amountToBuy / Math.pow(10, 8), function (err, txid) {
    console.log(txid)
});    