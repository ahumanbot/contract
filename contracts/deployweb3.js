const fs = require("fs");
const solc = require('solc')
let Web3 = require('web3');

let web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'));

var input = {
    'GiantToken.sol': fs.readFileSync('GiantToken.sol', 'utf8'),
    'Console.sol': fs.readFileSync('utils/Console.sol', 'utf8'),
    'Multiownable.sol': fs.readFileSync('utils/Multiownable.sol', 'utf8'),
    'SafeMath.sol': fs.readFileSync('utils/SafeMath.sol', 'utf8'),
    'AdvancedToken.sol': fs.readFileSync('token/AdvancedToken.sol', 'utf8'),
    'BitcoinToken.sol': fs.readFileSync('token/BitcoinToken.sol', 'utf8'),
    'MintableToken.sol': fs.readFileSync('token/MintableToken.sol', 'utf8'),
    'StandardToken.sol': fs.readFileSync('token/StandardToken.sol', 'utf8'),
};
let compiledContract = solc.compile({sources: input}, 1);
let abi = compiledContract.contracts['GiantToken.sol:GiantToken'].interface;
let bytecode = '0x'+compiledContract.contracts['GiantToken.sol:GiantToken'].bytecode;
let gasEstimate = web3.eth.estimateGas({data: bytecode});
let LMS = web3.eth.contract(JSON.parse(abi));

console.log("\n\n\n\n");
console.log("=========================ABI=================\n");
console.log(abi);
console.log("\n\n\n\n");

var lms = LMS.new("humanbot", "h@b.com", {
   from:web3.eth.coinbase,
   data:bytecode,
   gas: gasEstimate
 }, function(err, myContract){
    if(!err) {
       if(!myContract.address) {
           console.log(myContract.transactionHash) 
       } else {
           console.log(myContract.address) 
       }
    }
  });