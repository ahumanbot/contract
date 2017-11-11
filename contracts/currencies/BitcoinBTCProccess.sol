pragma solidity ^0.4.16;
import "./BitconBTC.sol";

contract BTCProccess {

  address public trustedBTCRelay = 0x52b31F0C56eea2F4D9c7795877D470D3a9D6903b;
  uint256 public lastTxHash;
  uint256 public ethBlock;

  /// @notice this function is invoked by BTCRelay and accepts confirmed transactions
  function processTransaction(bytes txn, uint256 txHash) public returns (int256) {
      log0("processTransaction txHash");

      uint n_outputs;
      uint halt;
      uint script_len;
      uint pos = 4; 

      
      (n_outputs, pos) = BTC.parseVarInt(txn, pos);
      halt = n_outputs;     

      log0("outputs");

      log(txn);

      for (uint8 i = 0; i < halt; i++) {
          uint256 _value = BTC.getBytesLE(txn, pos, 64);
          pos += 8;

          (script_len, pos) = BTC.parseVarInt(txn, pos);
          
          //script_starts[i] = pos;
          //script_lens[i] = script_len;          
          bytes20 _address = BTC.parseOutputScript(txn, pos, script_len);
          log1(bytes32(_value), _address);

          pos += script_len;         
      }


      // only allow trustedBTCRelay, otherwise anyone can provide a fake txn
      if (msg.sender == trustedBTCRelay) {
          //log1("processTransaction txHash, ", bytes32(txHash));
          ethBlock = block.number;
          lastTxHash = txHash;
        
          txn = "";
          // parse & do whatever with txn
          // For example, you should probably check if txHash has already
          // been processed, to prevent replay attacks.
          return 1;
      } else {
        log0("Untrusted relay");
      }      
      return 0;
  }
}