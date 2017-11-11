pragma solidity ^0.4.16;

contract BitcoinNodeProccess {
    address public trustedRelay = 0x52b31F0C56eea2F4D9c7795877D470D3a9D6903b;
    bytes[] public bitconTxs; 

    function proccessBitcoin() public returns (int256) {
        if (msg.sender == trustedRelay) {

        }
    }
}