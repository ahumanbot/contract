var ICO = artifacts.require("ICO.sol");

module.exports = function(deployer) {
  var start = (new Date().getTime()) / 1000 - 60 * 60;
  deployer.deploy(ICO, 
    start, 
    start + 60 * 60 * 7, 
    2400, //cap
    200, //softCap
    100, //number of tokens to team
    300, //ethPrice,
    10000, //btcPrice
  );  
};
