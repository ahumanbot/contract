// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // Match any network id
      gas: 4556000,
      //from: "0x52dfa4c60c71c1ef377eaf5c69077e1daaccb953"
    }
  }
}
