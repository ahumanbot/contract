require("babel-polyfill");
const Web3 = require('web3')
Web3.providers.HttpProvider.prototype.sendAsync = Web3.providers.HttpProvider.prototype.send
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545")) // Hardcoded development port
let util = require('./util.js');
let ICO = artifacts.require("./ICO.sol")



contract('Time travel tests', function(accounts) {
  
  var instance;
  var snap_id;
  var pow = Math.pow(10, 18); 

  before('Setup contract', async function() {   
    ICO.deployed().then(function(_instance) {
      instance = _instance;        
    })
  })  

  util.itlog("Should forward time for 4 days and check that ico is not ended", function(done) {
    util.timeTravel(86400 * 4, function() {
      instance.isEnded.call().then(function(value) {
        assert.equal(value, false, "ICO is ended but should not");

        done()
      })  
    })
  });

  util.itlog("Should forward time for 7 days and check that ico is ended", function(done) {
    util.timeTravel(86400 * 7, function() {
      instance.isEnded.call().then(function(value) {
        assert.equal(value, true, "ICO is not ended but should");
        done()
      })  
    })
  })

  util.itlog("Should check that ICO is started", function(done) {
    instance.isStarted.call().then(function(isStarted) {
      assert.equal(isStarted, true, "ICO not started but should")
      done()
    })
  })

  util.itlog("Should check that ICO is not succeed", function(done) {
    instance.isSucceed.call().then(function(value) {
      assert.equal(value, false, "ICO is succeed but should not");
      done();
    })
  })

});