// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract VestingToken is ERC20 {
    constructor(uint256 _initialSupply) ERC20("Test Vesting Token", "VST"){
        _mint(msg.sender, _initialSupply);
    }
}