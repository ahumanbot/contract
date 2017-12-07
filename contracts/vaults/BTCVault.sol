pragma solidity ^0.4.18;

import "./RefundVault.sol";
import '../utils/Multiownable.sol';

contract BTCVault is Multiownable, RefundVault {
  function BTCVault(address _wallet) public 
  RefundVault(_wallet)
  {
  }

  function deposit(address investor, uint256 value) onlyAnyOwner public {
    deposited[investor] = deposited[investor].add(value);
  }
}