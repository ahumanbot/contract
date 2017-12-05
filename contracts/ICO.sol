pragma solidity ^0.4.18;

import "./token/MintableToken.sol";
import "./utils/Multiownable.sol";


contract BaseICO {
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

  function BaseICO(uint256 _startTime, uint256 _endTime) {
    startTime = _startTime;
    endTime = _endTime;
  }
}

contract Bonus is BaseICO {
  function getTokenAmountPerHundredeUSD() public constant returns (uint256) {
    if (now - startTime <= 3 days) {
      return 130;
    } else if (now - startTime <= 5 days) {
      return 115;
    }
    return 100;
  }
}

contract BitcoinAccept is MintableToken, Bonus, Multiownable {

    // Address of node which proccess bitcoin transactions
    address public trustedRelay;

    // Bitcoin transactions
    mapping(bytes => bool) bitcoinTxs;
    
    // Bitcoin addresses where income will be send
    mapping(address => bytes) bitcoinAdresses;

    uint256 public btcPrice;

    function BitcoinAccept(uint256 _btcPrice) {
      btcPrice = _btcPrice;
    }

    modifier notProccessed(bytes txId) {
        if (isTxProccessed(txId)) throw;
        _;
    }

    modifier isTrustedRelay() {
        if (msg.sender != trustedRelay) throw;
        _;
    }

    function isTxProccessed(bytes txId) public constant returns (bool) {
        return (bitcoinTxs[txId] == true);
    }

    function setTrustedRelay(address _relay) public onlyMainOwner returns (bool) {
        trustedRelay = _relay;
        return true;
    }
   
    function proccessBitcoin(bytes txId, uint256 value, bytes btcaddress, address _etherAddress) public isTrustedRelay notProccessed(txId) {        
        uint tokens = value.mul(btcPrice).mul(getTokenAmountPerHundredeUSD()).div(100).div(10**8);

        //error will be throwed if balances[this] < tokens in SafeMath class
        bitcoinTxs[txId] = true;
        balances[this] = balances[this].sub(tokens);
        //address etherAddress = address(_etherAddress);
        balances[_etherAddress] = balances[_etherAddress].add(tokens);
        //Write bitcoin address
        bitcoinAdresses[_etherAddress] = btcaddress;
        
        Transfer(this, _etherAddress, tokens);    
        //Transfer(btcaddress, this, value); // Display how much BTC received
        TokenPurchase(msg.sender, msg.value, tokens);     
    }

    
}

// @notice ICO contract
// @dev A BaseICO contract with stages of tokens-per-eth based on time elapsed
// Capped by maximum number of tokens; Time constrained
contract ICO is MintableToken, BaseICO, Bonus, Multiownable, BitcoinAccept {
  using SafeMath for uint256;

  // Price in USD for 1 ETH
  uint256 public ethPrice;

  // Number of tokens that will be released for sale
  uint256 public tokenCap;
  //uint256 public tokenCap = 400 * 10**18;

  // Minimum summ to achieve
  uint256 public softCap;

  // Number of tokens that will be released for project team USD
  uint256 public numberOfTeamTokens;

  // The address where the funds are withdrawn
  address public wallet;
  
  // Team wallet where team tokens will be send
  address public teamWallet;

  // Bitcoint address where the funds are withdrawn
  address public bitcoinwallet;

  function ICO(uint _startTime, uint _endTime, uint256 _tokenCap, uint256 _softCap, uint256 _numberOfTeamTokens, uint256 _ethPrice, uint256 _btcPrice) 
  BitcoinAccept(_btcPrice)
  BaseICO(_startTime, _endTime)
  {
    //require(_startTime >= now - 15 minutes);
    //require(_endTime > _startTime);

    tokenCap = _tokenCap * 10**18;
    softCap = _softCap * 10**18;
    numberOfTeamTokens = _numberOfTeamTokens * 10**18;
    ethPrice = _ethPrice;
    
    wallet = msg.sender;
    teamWallet = msg.sender;

    mint(this, tokenCap);
    mint(teamWallet, numberOfTeamTokens);
  }
  

  address[] public addresses;
  uint256 public addrCount;

  // @notice buy tokens for ethereum
  function buy() payable returns(uint256) {
    require(msg.sender != 0x0);
    require(msg.value != 0);
    require(isStarted());
    require(!isEnded());

    if (balances[msg.sender] == 0) {
      addresses.push(msg.sender);
      addrCount++;
    }

    //Check whether optional data is present
    require(msg.data.length != 0); 
 
    uint256 tokens = msg.value.mul(ethPrice).mul(getTokenAmountPerHundredeUSD()).div(100);
    
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
  
  // @notice Check whether ICO has started.
  function isStarted() public constant returns (bool) {
    return now >= startTime;
  }

  function isEnded() public constant returns (bool) {
    return now > endTime;
  }

  function isSucceed() public constant returns (bool) {
    return tokenCap - balanceOf(this) >= softCap;
  }

  // @notice "multisig" withdraw if soft cap is reached
  function withdraw() payable onlyManyOwners {
    require(isSucceed());
    wallet.transfer(msg.value);
  }

  // @notice refund on ico ended and soft cap not reached
  function refund() public {
    require(isEnded() && !isSucceed());

    uint256 value = balances[msg.sender].div(ethPrice);
    balances[msg.sender] = 0;
    msg.sender.transfer(value); 
  }

}
