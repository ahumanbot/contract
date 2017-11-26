var GiantICO = artifacts.require("GiantICO.sol");

module.exports = function(deployer) {
  var start = (new Date().getTime()) / 1000 - 60 * 60;
  deployer.deploy(GiantICO, start, start + 86400 * 7, 400, 100, 200);  

  //(new Date().getTime()) / 1000, (new Date().getTime()) / 1000 + 5)
};
