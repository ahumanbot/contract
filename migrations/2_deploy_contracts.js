var ICO = artifacts.require("ICO.sol");

module.exports = function(deployer) {
  var start = (new Date().getTime()) / 1000 - 60 * 60;
  deployer.deploy(ICO, start, start + 60 * 60 * 7, 2400, 100, 200);  
};
