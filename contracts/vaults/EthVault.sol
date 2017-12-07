pragma solidity ^0.4.18;

import "./RefundVault.sol";

contract EthVault is RefundVault {
  function EthVault(address _wallet) public 
  RefundVault(_wallet)
  {
  }
}