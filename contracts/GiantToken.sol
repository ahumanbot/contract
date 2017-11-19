pragma solidity ^0.4.16;

import "./token/StandardToken.sol";
import "./utils/Multiownable.sol";
//import "./utils/Console.sol";

// @notice ICO contract
// @dev A crowdsale contract with stages of tokens-per-eth based on time elapsed
// Capped by maximum number of tokens; Time constrained
contract GiantToken is StandardToken, Multiownable {
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
  //uint256 public tokenCap = 21000000 * 10**18;
  uint256 public tokenCap = 400 * 10**18;

  // Minimum summ to achieve
  uint256 public softCap = 40 * 10**18;

  // Number of tokens that will be released for project team USD
  //uint256 public numberOfTeamTokens = 3000000 * 10**18;
  uint256 public numberOfTeamTokens = 300 * 10**18;
  
  // Team wallet where team tokens will be send
  address public teamWallet;

  // The address where the funds are withdrawn
  address public wallet;

  // Bitcoint address where the funds are withdrawn
  address public bitcoinwallet;

  // Amount of ethereum sended by each address
  mapping(address => uint) public ethSend;

  function GiantToken() {
    startTime = now;
    endTime = now.add(7 days);

    wallet = msg.sender;
    teamWallet = msg.sender;

    totalSupply = totalSupply.add(tokenCap);
    balances[this] = tokenCap;

    totalSupply = totalSupply.add(numberOfTeamTokens);
    balances[teamWallet] = numberOfTeamTokens;

    //mint(this, tokenCap);
    //mint(teamWallet, numberOfTeamTokens);
  }

  address public trustedRelay = 0x52b31F0C56eea2F4D9c7795877D470D3a9D6903b;

  // Bitcoin transactions
  mapping(bytes32 => bool) bitcoinTxs;
  
  // Bitcoin addresses where income will be send
  mapping(address => bytes) bitcoinAdresses;

  uint256 btctousd = 8000;
  function proccessBitcoin(bytes32 txHash, uint256 value, bytes btcaddress, bytes32 _etherAddress) public returns (int256) {
      require(msg.sender == trustedRelay);
      require(bitcoinTxs[txHash] != true);
      
      bitcoinTxs[txHash] = true;
      uint tokens = value * btctousd;
      balances[this] = balances[this].sub(tokens);

      address etherAddress = address(_etherAddress);
      balances[etherAddress] = balances[etherAddress].add(tokens);
      //Write bitcoin address
      bitcoinAdresses[etherAddress] = btcaddress;
      
      Transfer(this, msg.sender, tokens);    
      TokenPurchase(msg.sender, msg.value, tokens);     
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

    //Check whether optional data is present
    require(msg.data.length != 0); 
 
    uint256 tokens = getCurrentBonus(msg.value * ethereumPrice);
    tokensSold += tokens;
    
    //Transfer tokens from contract to investor
    balances[this] = balances[this].sub(tokens);
    balances[msg.sender] = balances[msg.sender].add(tokens);
    //Write bitcoin address
    bitcoinAdresses[msg.sender] = msg.data;
    
    Transfer(this, msg.sender, tokens);    
    TokenPurchase(msg.sender, msg.value, tokens);
  }

  // @notice fallback function
  function () payable {
    buy();
  }
  
  // @notice calculate token amount and add discount
  function getCurrentBonus(uint256 _value) public constant returns (uint256) {
    if (tokensSold <= tokenCap.mul(firstBonusEnd).div(100)) {
      _value = _value + _value.mul(firstBonusRate).div(100);
      return _value;
    } else if (tokensSold <= tokenCap.mul(secondBonusEnd).div(100)) {
      _value = _value + _value.mul(secondBonusRate).div(100);
      return _value;
    } else {
      return _value;
    }
  }

  // @notice Check whether ICO has started.
  function hasStarted() public constant returns (bool) {
    return now >= startTime;
  }

  function hasEnded() public constant returns (bool) {
    return now > endTime;
  }

  function isSucceed() public constant returns (bool) {
    return tokensSold >= softCap;
  }

  // @notice "multisig" withdraw if soft cap is reached
  function withdraw() payable onlyManyOwners {
    require(isSucceed());
    wallet.transfer(msg.value);
  }

  // @notice refund on ico ended and soft cap not reached
  function refund() public {
    require(hasEnded() && !isSucceed());

    uint256 value = ethSend[msg.sender];
    ethSend[msg.sender] = 0;
    msg.sender.transfer(value); 
  }
}
