pragma solidity ^0.4.18;

import "./token/MintableToken.sol";
import "./utils/Multiownable.sol";
import "./vaults/EthVault.sol";
import "./vaults/BTCVault.sol";

contract BaseICO is MintableToken {
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

// ICO accepting eth with refund
contract EthICO is MintableToken, BaseICO, Multiownable {
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

  //List of addresses for future balance iterating
  address[] public addresses;

  // Bitcoin addresses where income will be send
  mapping(address => bytes) public bitcoinAdresses;

  EthVault public ethVault;
  
  BTCVault public btcVault;

  function addressesSize() public returns (uint) {
    return addresses.length;
  }

  function EthICO(uint256 _startTime, uint256 _endTime, 
    uint256 _tokenCap, uint256 _softCap, uint256 _numberOfTeamTokens, uint256 _ethPrice,
    address _ethVault) 
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

    ethVault = EthVault(_ethVault);

    mint(this, tokenCap);
    mint(teamWallet, numberOfTeamTokens);
  }  

  // @notice buy tokens for ethereum
  function buy() payable {
    require(msg.sender != 0x0);
    require(msg.value != 0);
    require(isStarted());
    require(!isEnded());
    require(msg.data.length != 0);


    _buy(msg.sender, msg.data, msg.value.mul(ethPrice));
    ethVault.deposit.value(msg.value)(msg.sender);  
  }

  // @notice fallback function
  function () payable {
    buy();
  }

  function _buy(address eth, bytes btc, uint256 value) internal {
    if (balances[eth] == 0) {
      addresses.push(eth);
    }

    uint256 tokens = value.mul(getTokenAmountPerHundredeUSD()).div(100);
    
    //Transfer tokens from contract to investor
    balances[this] = balances[this].sub(tokens);
    balances[eth] = balances[eth].add(tokens);
    //Write bitcoin address
    bitcoinAdresses[eth] = btc;
    
    Transfer(this, eth, tokens);    
    TokenPurchase(eth, value, tokens);
  }

  function getTokenAmountPerHundredeUSD() public constant returns (uint256) {
    if (now - startTime <= 3 days) {
      return 130;
    } else if (now - startTime <= 5 days) {
      return 115;
    }
    return 100;
  }

  // @notice "multisig" withdraw if soft cap is reached
  function withdraw() payable onlyManyOwners {
    require(isSucceed());
    
    ethVault.close();
  }

  // @notice refund on ico ended and soft cap not reached
  function refund() public {
    require(isEnded() && !isSucceed());

    ethVault.refund(msg.sender);
    btcVault.refund(msg.sender);
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
}

// Extension for EthICO allowing to accept bitcoins 
contract ICO is Multiownable, EthICO {
    // Address of node which proccess bitcoin transactions
    address public trustedRelay;

    // Bitcoin transactions
    mapping(bytes => bool) bitcoinTxs;

    uint256 public btcPrice;

    BTCVault public btcVault;

    function ICO(uint _startTime, uint _endTime, 
      uint256 _tokenCap, uint256 _softCap, uint256 _numberOfTeamTokens, uint256 _ethPrice, uint256 _btcPrice,
      address _ethVault, address _btcVault) 
    EthICO(_startTime, _endTime, _tokenCap, _softCap, _numberOfTeamTokens, _ethPrice, _ethVault) 
    {
      btcPrice = _btcPrice;
      btcVault = BTCVault(_btcVault);
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
   
    function proccessBitcoin(bytes txId, uint256 value, bytes _btcAddr, address _etherAddr) public isTrustedRelay notProccessed(txId) {   
      require(_etherAddr != 0x0);
      require(value != 0);
      require(isStarted());
      require(!isEnded());

      bitcoinTxs[txId] = true;
      uint256 usd = value.mul(btcPrice).div(10**8);
      _buy(_etherAddr, _btcAddr, usd); 
      btcVault.deposit(_etherAddr, usd.mul(10**18).div(ethPrice));
    }    

    // @notice "multisig" withdraw if soft cap is reached
    function withdraw() payable onlyManyOwners {
      require(isSucceed());
      
      ethVault.close();
      btcVault.close();
    }


    /** DEV METHODS FOR TEST PURPOSE */

    function isRefundable() public constant returns(bool) {
      return isEnded() && !isSucceed();
    }

    function getBalance(address addr) view returns (uint){
        return addr.balance;
    }
}

