/*
var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
};
*/


//var BTC = artifacts.require("./BTC.sol");
var GiantToken = artifacts.require("./GiantToken.sol");
/*
var SafeMath = artifacts.require("./SafeMath.sol");
var StandadToken = artifacts.require("./StandardToken.sol");
var Ownable = artifacts.require("./Ownable.sol");
var Claimable = artifacts.require("./Claimable.sol");
*/


module.exports = function(deployer) {
  //deployer.deploy(BTC);
  //deployer.link(BTC, ICO);
  
  //var account = "0x52b31F0C56eea2F4D9c7795877D470D3a9D6903b";
  var account = "0x0faa3915e53a8c835670cd53ff71863002aa2313";

  startTime = 0;
  deployer.deploy(GiantToken, "");
  
};
