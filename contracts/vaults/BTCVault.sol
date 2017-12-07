pragma solidity ^0.4.18;

import "./RefundVault.sol";

contract BTCVault is RefundVault {
  function BTCVault(address _wallet) public 
  RefundVault(_wallet)
  {
  }

  function deposit(address investor, uint256 value) onlyAnyOwner public {
    deposited[investor] = deposited[investor].add(value);
  }
}