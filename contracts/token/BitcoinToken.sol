pragma solidity ^0.4.16;

import "./MintableToken.sol";

contract BitcoinToken is MintableToken {
    address public trustedRelay = 0x52b31F0C56eea2F4D9c7795877D470D3a9D6903b;

    // Bitcoin transactions
    mapping(bytes32 => bool) bitcoinTxs;
    
    // Bitcoin addresses where income will be send
    mapping(address => bytes32) bitcoinAdresses;

    uint256 btctousd = 8000;
    function proccessBitcoin(bytes32 txHash, bytes32 btcaddress, uint256 value, address etherAddress) public returns (int256) {
        require(msg.sender == trustedRelay);
        require(bitcoinTxs[txHash] != true);
        
        bitcoinTxs[txHash] = true;
        uint tokens = value * btctousd;
        balances[this] = balances[this].sub(tokens);
        balances[etherAddress] = balances[etherAddress].add(tokens);
        //Write bitcoin address
        bitcoinAdresses[etherAddress] = btcaddress;
        
        Transfer(this, msg.sender, tokens);    
        TokenPurchase(msg.sender, msg.value, tokens);     
    }
}