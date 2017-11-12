pragma solidity ^0.4.16;

contract BitcoinNodeProccess {
    address public trustedRelay = 0x52b31F0C56eea2F4D9c7795877D470D3a9D6903b;
    //bytes[] public bitconTxs; 

    mapping(bytes32 => bool) bitcoinTxs;

    uint256 btctoeth = 9000 / 300;
    function proccessBitcoin(bytes32 txHash, uint256 value, address etherAddress) public returns (int256) {
        require(msg.sender == trustedRelay);
        require(bitcoinTxs[txHash] != true);

        bitcoinTxs[txHash] = true;        
    }
}