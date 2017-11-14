pragma solidity ^0.4.16;


import "./GiantToken.sol";

contract TestToken is GiantToken {
    uint256 public tokenCap = 21000000 * 10**18;

    // Minimum summ to achieve
    uint256 public softCap = 400000 * 10**18;

    // Number of tokens that will be released for project team USD
    uint256 public numberOfTeamTokens = 3000000 * 10**18;
}