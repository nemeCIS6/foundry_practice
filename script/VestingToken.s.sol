// SPDX-License-Identifier : MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {VestingToken} from "../src/practice/vesting/VestingToken.sol";

contract DeployVestingToken is Script {

    uint256 public constant INITIAL_SUPPLY = 1000000;

    function run() external {
        vm.startBroadcast();
        new VestingToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
    }
}