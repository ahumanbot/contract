var GiantToken = artifacts.require("./GiantToken.sol");

module.exports = function(deployer) {
  deployer.deploy(GiantToken);  
};
