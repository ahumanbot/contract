pragma solidity ^0.4.16;

import "./MintableToken.sol";
import "../utils/Multiownable.sol";

contract BitcoinAcceptToken is MintableToken, Multiownable {
    address public trustedRelay = 0x7547c13272a4bff4b098f57cb3d291e21b42895c;

    // Bitcoin transactions
    mapping(bytes32 => bool) bitcoinTxs;
    
    // Bitcoin addresses where income will be send
    mapping(address => bytes) bitcoinAdresses;

    uint256 btctousd = 8000;
    function proccessBitcoin(bytes32 txHash, uint256 value, bytes btcaddress, bytes32 _etherAddress) public returns (int256) {
        require(isTrustedRelay());
        require(isTxProccessed(txHash) == false);
        
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

    function isTxProccessed(bytes32 txHash) public view returns (bool) {
        return bitcoinTxs[txHash] != true;
    }

    function isTrustedRelay() public view returns (bool) {
        return msg.sender == trustedRelay;
    }

    function setTrustedRelay(address _relay) public onlyMainOwner returns (bool) {
        trustedRelay = _relay;
        return true;
    }
}