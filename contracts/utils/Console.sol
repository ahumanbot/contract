pragma solidity ^0.4.2;

contract Console {
    event LogUint(uint);
    function log(uint x) {
        LogUint(x);
    }
    
    event LogInt(int);
    function log(int x) {
        LogInt(x);
    }
    
    event LogBytes(bytes);
    function log(bytes x) {
        LogBytes(x);
    }
    
    event LogBytes32(bytes32);
    function log(bytes32 x) {
        LogBytes32(x);
    }

    event LogAddress(address);
    function log(address x) {
        LogAddress(x);
    }

    event LogBool(bool);
    function log(bool x) {
        LogBool(x);
    }
}