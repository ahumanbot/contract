pragma solidity ^0.4.16;

import "./StandardToken.sol";
import "./Multiownable.sol";
import "./currencies/BitcoinNodeProccess.sol";
import "./Console.sol";

// @notice ICO contract
// @dev A crowdsale contract with stages of tokens-per-eth based on time elapsed
// Capped by maximum number of tokens; Time constrained
contract ICO is StandardToken, BitcoinNodeProccess, Multiownable, Console {
  using SafeMath for uint256;
  uint256 public tokensSold = 0;

  // Name for the Decision Token to appear in ERC20 wallets
  string public constant name = "Illuminati Token";
  // Symbol for the Decision Token to appear in ERC20 wallets
  string public constant symbol = "IT";
  // Number of decimals for token display
  uint8 public constant decimals = 18;

  // Start timestamp when investments are open to the public.
  uint256 public startTime;
  // End time. investments can only go up to this timestamp.
  uint256 public endTime;

  // Bonus for first stage
  uint256 public constant firstBonusRate = 30;
  // Bonus for second stage
  uint256 public constant secondBonusRate = 15;

  // Percent of summ needed to reach to finish first stage
  uint256 public constant firstBonusEnd = 30;
  // Percent of summ needed to reach to finish second stage
  uint256 public constant secondBonusEnd = 60;

  // Price in USD for 1 ETH
  uint256 public constant ethereumPrice = 300;

  // Number of tokens that will be released for sale
  uint256 public tokenCap;

  // Number of tokens that will be released for project team USD
  uint256 public numberOfTeamTokens;
  // Team wallet where team tokens will be send
  address public teamWallet;

  // The address where the funds are withdrawn
  address public wallet;
  // Bitcoint address where the funds are withdrawn
  address public bitcoinwallet;

  

  // Bitcoin addresses where income will be send
  mapping(address => bytes) bitcoinAdresses;

  event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
  // @notice Constructor
  // @param _startTime: A timestamp for when the sale is to start.
  // @param _wallet - The wallet where the token sale proceeds are to be withdrawn
  function ICO(uint256 _tokenCap, uint256 _numberOfTeamTokens, uint256 _startTime, address _wallet, address _teamWallet) {
    require(_wallet != 0x0);
    require(_teamWallet != 0x0);

    tokenCap = _tokenCap * 10**18;
    numberOfTeamTokens = _numberOfTeamTokens * 10**18;
    startTime = _startTime;
    endTime = now.add(7 days);
    wallet = _wallet;
    teamWallet = _teamWallet;

    mint(this, tokenCap);
    mint(teamWallet, numberOfTeamTokens);
  }

  function getNumberOfTeamTokens() public constant returns(uint256) {
    return numberOfTeamTokens;
  }

  // @notice buy tokens for ethereum
  function buy() payable {
    require(msg.sender != 0x0);
    require(msg.value != 0);
    require(hasStarted());
    require(!hasEnded());

    //log0(bytes32(msg.data.length));
    require(msg.data.length > 10); 

    uint256 tokens = getCurrentBonus(msg.value * ethereumPrice);
    tokensSold += tokens;
    //mint(msg.sender, tokens);
    //transferFrom(this, msg.sender, tokens);
    balances[this] = balances[this].sub(tokens);
    balances[msg.sender] = balances[msg.sender].add(tokens);
    Transfer(this, msg.sender, tokens);
    
    bitcoinAdresses[msg.sender] = msg.data;    

    TokenPurchase(msg.sender, msg.value, tokens);
  }

  // @notice fallback function
  function () payable {
    buy();
  }
  
  // @notice calculate token amount and add discount
  function getCurrentBonus(uint256 _value) returns (uint256) {
    if (tokensSold <= tokenCap.mul(firstBonusEnd).div(100)) {
      _value = _value + _value.mul(firstBonusRate).div(100);
      return _value;
      //return _value + _value.mul(firstBonusRate).div(100);
    } else if (tokensSold <= tokenCap.mul(secondBonusEnd).div(100)) {
      _value = _value + _value.mul(secondBonusRate).div(100);
      return _value;
      //return _value + _value.mul(secondBonusRate).div(100);
    } else {
      return _value;
    }
  }

  // @notice Check whether ICO has started.
  function hasStarted() public returns (bool) {
    return now >= startTime;
  }

  function hasEnded() public returns (bool) {
    return now > endTime || isSucceed();
  }

  function isSucceed() public returns (bool) {
    return tokensSold >= tokenCap.mul(95).div(100);
  }

  // @notice Withdraw money by owner if ICO is ended and succeed
  function withdraw() payable onlyManyOwners {
    require(hasEnded());
    require(isSucceed());
    wallet.transfer(msg.value);
  }

  // @notice end ICO. if ending requirements met ICO will stop
  function endICO() {
    require(hasEnded());
    if (isSucceed()) {
      
    } else {
      
    }
  }

}
