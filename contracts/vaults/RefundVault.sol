pragma solidity ^0.4.18;

import '../utils/SafeMath.sol';
import '../utils/Multiownable.sol';

/**
 * @title RefundVault
 * @dev This contract is used for storing funds while a crowdsale
 * is in progress. Supports refunding the money if crowdsale fails,
 * and forwarding it if crowdsale is successful.
 */
contract RefundVault is Multiownable {
  using SafeMath for uint256;

  mapping (address => uint256) public deposited;
  address public wallet;

  event Closed();
  event RefundsEnabled();
  event Refunded(address indexed beneficiary, uint256 weiAmount);

  function RefundVault(address _wallet) public {
    //require(_wallet != address(0));
    wallet = _wallet;
  }

  function deposit(address investor) onlyAnyOwner public payable {
    deposited[investor] = deposited[investor].add(msg.value);
  }

  function close() onlyAnyOwner public {
    Closed();
    wallet.transfer(this.balance);
  }

  function refund(address investor) public {
    uint256 depositedValue = deposited[investor];
    deposited[investor] = 0;
    investor.transfer(depositedValue);
    Refunded(investor, depositedValue);
  }
}
