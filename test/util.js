
const evm_increaseTime = function (time) {
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
  
  const evm_mine = function () {
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

  const timeTravel = function(time, callback) {
    evm_increaseTime(time).then(function() {
        evm_mine().then(function() {
            callback()
        })
    })
  }


  var fs = require('fs');
  var tests = "";
  var itlog = function(txt, callback) {
    tests = tests + txt + "\n";

    
    fs.writeFile("tests.txt", tests, function(err) {
        if(err) {
            return console.log(err);
        }    
    }); 

    it(txt, callback)
  }

  module.exports = {
      evm_increaseTime: evm_increaseTime,
      evm_mine: evm_mine,
      evm_snapshot: evm_snapshot,
      evm_revert: evm_revert,
      timeTravel: timeTravel,
      itlog: itlog
  }