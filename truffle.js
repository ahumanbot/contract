// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // Match any network id
      //from: "0x52b31F0C56eea2F4D9c7795877D470D3a9D6903b",
      gas: 4560000,
    }
  }
}
