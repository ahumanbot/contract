pragma solidity ^0.4.16;

import "./MintableToken.sol";
import "../utils/Multiownable.sol";

contract BitcoinAcceptToken is MintableToken, Multiownable {

    address public trustedRelay;

    // Bitcoin transactions
    mapping(bytes => bool) bitcoinTxs;
    
    // Bitcoin addresses where income will be send
    mapping(address => bytes) bitcoinAdresses;

    uint256 satoshitousd = 12500;
    function proccessBitcoin(bytes txId, uint256 value, bytes btcaddress, address _etherAddress) public returns (int256) {
        //require(isTrustedRelay());
        //require(isTxProccessed(txId) == false);

        bitcoinTxs[txId] = true;
        uint tokens = value.div(satoshitousd);
        balances[this] = balances[this].sub(tokens);

        //address etherAddress = address(_etherAddress);
        balances[_etherAddress] = balances[_etherAddress].add(tokens);
        //Write bitcoin address
        bitcoinAdresses[_etherAddress] = btcaddress;
        
        Transfer(this, msg.sender, tokens);    
        TokenPurchase(msg.sender, msg.value, tokens);     

        return 1;
    }

    function isTxProccessed(bytes txId) public view returns (bool) {
        return bitcoinTxs[txId] != true;
    }

    function isTrustedRelay() public view returns (bool) {
        return msg.sender == trustedRelay;
    }

    function setTrustedRelay(address _relay) public onlyMainOwner returns (bool) {
        trustedRelay = _relay;
        return true;
    }
}