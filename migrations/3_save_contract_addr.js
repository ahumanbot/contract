var ICO = artifacts.require("ICO.sol");
var fs = require('fs');

module.exports = function(deployer, network, accounts) {
    ICO.deployed().then(function(instance) {
        fs.writeFile("../frontend/public/ether.txt", instance.address, function(err) {
            if(err) {
                return console.log(err);
            }
        }); 
    })
};
