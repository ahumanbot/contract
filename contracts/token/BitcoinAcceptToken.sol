pragma solidity ^0.4.16;

import "./MintableToken.sol";
import "../utils/Multiownable.sol";
import "../utils/Console.sol";

contract BitcoinAcceptToken is MintableToken, Multiownable, Console {

    // Address of node which proccess bitcoin transactions
    address public trustedRelay;

    // Bitcoin transactions
    mapping(bytes => bool) bitcoinTxs;
    
    // Bitcoin addresses where income will be send
    mapping(address => bytes) bitcoinAdresses;

    uint256 public satoshitousd = 10000;

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
        uint tokens = value.div(satoshitousd);

        //error will be throwed if balances[this] < tokens in SafeMath class
        balances[this] = balances[this].sub(tokens);
        bitcoinTxs[txId] = true;
        //address etherAddress = address(_etherAddress);
        balances[_etherAddress] = balances[_etherAddress].add(tokens);
        //Write bitcoin address
        bitcoinAdresses[_etherAddress] = btcaddress;
        
        Transfer(this, _etherAddress, tokens);    
        //Transfer(btcaddress, this, value); // Display how much BTC received
        TokenPurchase(msg.sender, msg.value, tokens);     
    }

    
}