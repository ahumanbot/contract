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

    uint256 satoshitousd = 12500;

    /*
    modifier notProccessed(bytes txId) {
        if (isTxProccessed(txId)) throw;
        _;
    }

    modifier isTrustedRelay() {
        if (msg.sender != trustedRelay) throw;
        _;
    }
    */

    function isTxProccessed(bytes txId) constant returns (bool) {
        return (bitcoinTxs[txId] == true);
    }

    function isTrustedRelay() returns (bool) {
        return (msg.sender == trustedRelay);        
    }

    function setTrustedRelay(address _relay) public onlyMainOwner returns (bool) {
        trustedRelay = _relay;
        return true;
    }

    //isTrustedRelay notProccessed(txId) 
    function proccessBitcoin(bytes txId, uint256 value, bytes btcaddress, address _etherAddress) public {
        require(isTrustedRelay());
        require(!isTxProccessed(txId));

        LogBytes("Inited");
        
        bitcoinTxs[txId] = true;
        uint tokens = value.div(satoshitousd);

        LogBytes("Divided");

        balances[this] = balances[this].sub(tokens);

        //address etherAddress = address(_etherAddress);
        balances[_etherAddress] = balances[_etherAddress].add(tokens);
        //Write bitcoin address
        bitcoinAdresses[_etherAddress] = btcaddress;
        
        Transfer(this, msg.sender, tokens);    
        Transfer(msg.sender, this, value); // Display how much BTC received
        TokenPurchase(msg.sender, msg.value, tokens);     
    }

    
}