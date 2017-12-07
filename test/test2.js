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

  let timeUnit = 3600;

  before('Setup contract', async function() {   
    ICO.deployed().then(function(_instance) {
      instance = _instance;        
    })
  })  
  
  util.itlog("Sending 0.33 ether", function(done) {
    instance.buy({from: accounts[1], value: web3.utils.toWei("0.33", "ether"), data: "1M7AxbrMdYgi2nuMV334keKkmJT7MK3jbB"})
    .then(function(tx) {
      assert.isOk(tx.receipt)      
      done();
    })
  })

  util.itlog("Should forward time for 4 time units and check that ico is not ended", function(done) {
    util.timeTravel(timeUnit * 4, function() {
      instance.isEnded.call().then(function(value) {
        assert.equal(value, false, "ICO is ended but should not");

        done()
      })  
    })
  });

  util.itlog("Should forward time for 7 time units and check that ico is ended", function(done) {
    util.timeTravel(timeUnit * 7, function() {
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

  util.itlog("Should check value of eth send stored in contract", function(done) {
    instance.ethSend.call(accounts[1]).then(function(value) {
      assert.equal(value.valueOf(), 330000000000000000, "Should equal 0.33 eth");
      done()
    })
  })

  util.itlog("Should refund", function(done) {
    instance.refund({from: accounts[1]}).then(function(tx) {
      assert.isOk(tx.receipt, "Refund failed.");
      web3.eth.getBalance(accounts[1]).then(function(balance) {
        console.log(balance / Math.pow(10, 18))
      })
      done();
    })
  })
});