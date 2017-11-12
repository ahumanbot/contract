require("babel-polyfill");
const Web3 = require('web3')
let web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"))
let GiantToken = artifacts.require("./GiantToken.sol", )
let StandardToken = artifacts.require("./token/StandardToken.sol");


//web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [86400], id: 0})

contract('', function(accounts) {

  var ownerAccount = accounts[0];
    
  const params = {
    _tokenCap: 500,
    _numberOfTeamTokens: 100,
    _startTime: 0,
    _wallet: ownerAccount,
    _teamWallet: ownerAccount
  };

  var instance;
  var pow = Math.pow(10, 18);

  before('Setup contract', async function() {
    //instance = await GiantToken.new(...Object.values(params));
    
    
    GiantToken.deployed().then(function(_instance) {
        instance = _instance;

        
    })
    
  })
  

  it("Should check number of team tokens", function(done) {
    instance.balanceOf.call(ownerAccount).then(function(balance) {
        assert.equal(balance.valueOf(), params._numberOfTeamTokens * pow, "Number of team tokens is invalid");
        done()
    });
  });


  it("Should check is ico started", function(done) {
    instance.hasStarted.call().then(function(isStarted) {
      assert.equal(isStarted, true, "ICO not started but should")
      done()
    })
  })

  it("Should check that is is not succeed", function(done) {
    instance.isSucceed.call().then(function(value) {
      assert.equal(value, false, "ICO is succeed but should not");
      done();
    })
  })

  it("Should check that is is not finished", function(done) {
    instance.hasEnded.call().then(function(value) {
      assert.equal(value, false, "ICO is finished but should not")
      done()
    })
  })

  /*
  it("Should deposit 1 ether", function(done) {
    instance.buy({from:accounts[3], to:instance.address, value: web3.utils.toWei(0.33, "ether")})
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
  */

  function printBalances(accounts) {
    accounts.forEach(function(ac, i) {
      console.log(i, web3.fromWei(web3.eth.getBalance(ac), 'ether').toNumber())
    })
  }

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
  

  */
})