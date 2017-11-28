require("babel-polyfill");
const Web3 = require('web3')
Web3.providers.HttpProvider.prototype.sendAsync = Web3.providers.HttpProvider.prototype.send
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545")) // Hardcoded development port

let ICO = artifacts.require("./ICO.sol")

const timeTravel = function (time) {
  return new Promise((resolve, reject) => {
    web3.currentProvider.sendAsync({
      jsonrpc: "2.0",
      method: "evm_increaseTime",
      params: [time], 
      id: new Date().getTime()
    }, (err, result) => {
      if(err){ return reject(err) }
      return resolve(result)
    });
  })
}

const evm_snapshot = function () {
  return new Promise((resolve, reject) => {
    web3.currentProvider.sendAsync({
      jsonrpc: "2.0",
      method: "evm_snapshot"
    }, (err, result) => {
      if(err){ return reject(err) }
      return resolve(result.result)
    });
  })
}


const evm_revert = function (_id) {
  return new Promise((resolve, reject) => {
    web3.currentProvider.sendAsync({
      jsonrpc: "2.0",
      method: "evm_revert",
      id: _id
    }, (err, result) => {
      if(err){ return reject(err) }
      return resolve(result)
    });
  })
}

const mineBlock = function () {
  return new Promise((resolve, reject) => {
    web3.currentProvider.sendAsync({
      jsonrpc: "2.0",
      method: "evm_mine"
    }, (err, result) => {
      if(err){ return reject(err) }
      return resolve(result)
    });
  })
}

var request = require('request')

function setTime(_time, callback) {
  request({
    url: "http://localhost:8546",
    method: "POST",
    json: true,   
    body: {time: _time},
    timeout: 1000,
  }, function (error, response, body){
      callback()
  });
}



contract('Time travel tests', function(accounts) {
  
  var instance;
  var snap_id;
  var pow = Math.pow(10, 18); 

  before('Setup contract', async function() {   
    ICO.deployed().then(function(_instance) {
      instance = _instance;        
    })
  })  

  it("Should forward time for 3 days and check that ico is still not ended", function(done) {
    /*
    evm_snapshot().then(function(_snap_id) {
      snap_id = _snap_id
      console.log(snap_id)

      
    })
    */
    timeTravel(86400 * 7).then(function(res) {
      mineBlock().then(function(res) {
        instance.isEnded.call().then(function(value) {
          assert.equal(value, true, "ICO is ended but should");
          done()
        })  
      })
    })

    /*
    setTime((new Date()).getTime() / 1000 + 86400 * 7, function(response) {
      web3.currentProvider.sendAsync({
        jsonrpc: "2.0",
        method: "evm_mine"
      }, (err, result) => {
        instance.isEnded.call().then(function(value) {
          assert.equal(value, true, "ICO is not ended but should");
          done()
        })  
      });      
    })       
    */
    
  })


  it("Should forward time for 4 days and check is ico ended", function(done) {
    timeTravel(86400 * 4).then(function(res) {
      mineBlock().then(function(res) {
        instance.isEnded.call().then(function(value) {
          assert.equal(value, true, "ICO is not ended but should");

          done()
          /*
          evm_revert(snap_id).then(function() {
            done()
          })
          */
        })  
      })
    })
  });

  it("Should check that ICO is started", function(done) {
    instance.isStarted.call().then(function(isStarted) {
      assert.equal(isStarted, true, "ICO not started but should")
      done()
    })
  })

  it("Should check that ICO is not succeed", function(done) {
    instance.isSucceed.call().then(function(value) {
      assert.equal(value, false, "ICO is succeed but should not");
      done();
    })
  })

  


});