pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ICO.sol";

contract TestMetacoin {


  
  function testInitialBalanceUsingDeployedContract() {
    Console console = new Console();
    //ICO ico = ICO(DeployedAddresses.ICO());
    //Assert.equal(ico.numberOfTeamTokens, 100, "Err");

    log("eadsad");
    //Assert.equal(ico.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
  }
  

  /*
  function testInitialBalanceWithNewMetaCoin() {
    ICO ico = new ICO(500, 100, 0, 0x7e41264ddf86a7b6309c4acfc0a0659364e144b2, 0x7e41264ddf86a7b6309c4acfc0a0659364e144b2);

    

    Assert.equal(ico.balanceOf(0x7e41264ddf86a7b6309c4acfc0a0659364e144b2), 500, "Owner should have 10000 MetaCoin initially");
  }
  */
}
