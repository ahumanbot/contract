var bitcoin = require('bitcoinjs-lib')
var testnet = bitcoin.networks.testnet


var dhttp = require('dhttp')

var alice = bitcoin.ECPair.fromWIF('L1uyy5qTuGrVXrmrsvHWHgVzW9kKdrp27wBC7Vs6nZDTF2BRUVwy')
var txb = new bitcoin.TransactionBuilder()

txb.addInput('61d520ccb74288c96bc1a2b20ea1c0d5a704776dd0164a396efec3ea7040349d', 0) // Alice's previous transaction output, has 15000 satoshis
txb.addOutput('1cMh228HTCiwS8ZsaakH8A8wze1JR5ZsP', 12000)
// (in)15000 - (out)12000 = (fee)3000, this is the miner fee

txb.sign(0, alice)

var tx = txb.build().toHex()

var bitcoin = require('bitcoin');
var client = new bitcoin.Client({
  host: 'localhost',
  port: 18332,
  user: 'bitcoin',
  pass: 'local321'
});

client.cmd('sendfrom', "1", "moFft8DzJxVQkirDrrkUYGsE4vsyKQ8hH1", 0.00001, function (err, tid) {
    if (err) {
        console.log(err)
    } else {
        console.log(tid)
    }
});



/*
client.getDifficulty(function(err, difficulty) {
    if (err) {
        return console.error(err);
    }

    console.log('Difficulty: ' + difficulty);
});
*/

var cs = require('coinstring')

var hash160 = "mysKEM9kN86Nkcqwb4gw7RqtDyc552LQoq" //hash representing uncompressed
var hash160Buf = new Buffer(hash160, 'hex')
var version = 0x00; //Bitcoin public address

//console.log(cs.encode(hash160Buf, version)); 
// => 16UjcYNBG9GTK4uq2f7yYEbuifqCzoLMGS

var id = "1";

function newAddress() {
    client.cmd('getnewaddress', id, function (err, addr) { 
        if (err) { 
            console.log(err);
        } else { 
            console.log(addr)
        } 
    });
}

/*
client.cmd('getaccount', "n2a7mu7SBJ7MtbnktXcjNxsa9c6R2VHKwH", function (err, acc) {
    client.cmd('getbalance', acc, function(err, balance) {
        console.log(balance)
    })
});

*/


/*
client.cmd('getnewaddress', "123", function(a, b) {
    console.log(b)
});




*/
/*

*/