// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {VestingWallet} from "../src/practice/vesting/VestingWallet.sol";
import "forge-std/console.sol";

contract DeployVestingWallet is Script {
    function run() external {
        uint64 start = uint64(block.timestamp);
        uint64 duration = 3600;
        address beneficiary = vm.envAddress("BENEFICIARY");

        vm.startBroadcast();

        VestingWallet vestingWallet = new VestingWallet(beneficiary, start, duration);

        vm.stopBroadcast();

        console.log("VestingWallet deployed to:", address(vestingWallet));
    }
}


