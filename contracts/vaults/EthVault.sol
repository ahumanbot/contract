pragma solidity ^0.4.18;

import "./RefundVault.sol";
import '../utils/Multiownable.sol';

contract EthVault is Multiownable, RefundVault {
  function EthVault(address _wallet) public 
  RefundVault(_wallet)
  {
  }
}