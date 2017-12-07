var ICO = artifacts.require("ICO.sol");
var EthVault = artifacts.require("vaults/EthVault.sol");
var BTCVault = artifacts.require("vaults/BTCVault.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(EthVault, accounts[0]).then(function() {
    return deployer.deploy(BTCVault, accounts[0]).then(function() {
      var start = (new Date().getTime()) / 1000 - 60 * 60;
      return deployer.deploy(ICO, 
        start, 
        start + 60 * 60 * 7, 
        2400, //cap
        200, //softCap
        100, //number of tokens to team
        300, //ethPrice,
        10000, //btcPrice,
        EthVault.address,
        BTCVault.address
      ).then(function() {
        EthVault.deployed().then(function(eth) {
          ICO.deployed().then(function(ico) {
            eth.transferOwnership([ico.address]);
          })          
        })

        BTCVault.deployed().then(function(btc) {
          ICO.deployed().then(function(ico) {
            btc.transferOwnership([ico.address]);
          })          
        })
      });
    })    
  })    
};
