let Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

var gRelayAddr = '0xAAFea276d3f1D248666EDa666895019d564e2DF6';
var gFeeVerifyFinney;

var GiantTokenContractClass = web3.eth.contract(giantAbi);
var gContract = GiantTokenContractClass.at(gRelayAddr);


function send() {
    var tx = foo.myFunction()
    console.log(tx)

    var objParam = { from: web3.eth.coinbase, value: web3.toWei(0.033, "ether"), gas: 200000, data: "1M7AxbrMdYgi2nuMV334keKkmJT7MK3jbB" };
    gContract.buy.sendTransaction(objParam, function(err, ethTx) {
        if (err) {
            console.log(err);
            console.log('@@@ relayTx error');
            return;
        }
    });
}