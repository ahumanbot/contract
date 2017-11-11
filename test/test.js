require("babel-polyfill");
const Web3 = require('web3')
let web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"))
let ICO = artifacts.require("./ICO")


contract('', function(accounts) {

  var ownerAccount = accounts[0];
    
  const params = {
    _tokenCap: 500,
    _numberOfTeamTokens: 100,
    _startTime: 0,
    _wallet: ownerAccount,
    _teamWallet: ownerAccount
  };

  var ico;
  var pow = Math.pow(10, 18);

  before('Setup contract', async function() {
    ico = await ICO.new(...Object.values(params));
    
    /*
    ICO.deployed().then(function(instance) {
        ico = instance;
    })
    */
  })
  

  it("Should check number of team tokens", function(done) {
    ico.balanceOf.call(ownerAccount).then(function(balance) {
        assert.equal(balance.valueOf(), params._numberOfTeamTokens * pow, "Number of team tokens is invalid");
        done()
    });
  });

  it("Should deposit 1 ether", function(done) {
    ico.buy({from:accounts[3], to:ico.address, value: web3.toWei(0.33, "ether")})
    .then(function(tx) {
      assert.isOk(tx.receipt)

      done()
    }, function(error) {
        //{from:accounts[3], to:ico.address, value: web3.toWei(1, "ether")}
        console.error(error)
        assert.equal(true, false);
        done()
      })
  })

    /*
    before('setup contract for each test', async function () {
        ico = await ICO.new(...Object.values(params))
    })
    it('has an owner', async function () {
        assert.equal(await ico.owner(), accounts[0])
    })
    it('assigns team tokens', async function() {
        console.log(await ico.getNumberOfTeamTokens.call())
    })
    */
  /*

  // A convenience to view account balances in the console before making changes.
  //printBalances(accounts)
  // Create a test case for retreiving the deployed ICO.
  // We pass 'done' to allow us to step through each test synchronously.
  it("Should retrive deployed ICO.", function(done) {
    // Check if our instance has deployed
    ICO.deployed().then(function(instance) {
      // Assign our contract instance for later use
      ico = instance

      // Pass test if we have an object returned.
      assert.isOk(ico)
      // Tell Mocha move on to the next sequential test.
      done()
    })
  })

  it('has an owner', function (done) {
    assert.equal(ico.owner(), owner)

    done()
  })
  
  it("Should check amount of tokens on team account.", function(done) {
      
    done()  
  })
  
  

  // Utility function to display the balances of each account.
  function printBalances(accounts) {
    accounts.forEach(function(ac, i) {
      console.log(i, web3.fromWei(web3.eth.getBalance(ac), 'ether').toNumber())
    })
  }

  */
})