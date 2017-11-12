// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // Match any network id
      gas: 4556000,
      //from: "0xe430cc643580e8fcfc9fa4a37fc7f623ed77d43a"
    },
    ropsten: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // Match any network id
      gas: 4556000
    },
  }
}
