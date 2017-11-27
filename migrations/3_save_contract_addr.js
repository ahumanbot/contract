var GiantICO = artifacts.require("GiantICO.sol");
var fs = require('fs');

module.exports = function(deployer) {
    GiantICO.deployed().then(function(instance) {
        fs.writeFile("../frontend/public/ether.txt", instance.address, function(err) {
            if(err) {
                return console.log(err);
            }
        }); 
    })
};
