// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../src/practice/vesting/VestingWallet.sol";

contract VestingWalletTest {
    VestingWallet public vestingWallet;
    address user1 = address(1);

    function setUp() public{
        vestingWallet = new VestingWallet{value: 10 ether}(
            user1,
            1732785200,
            3600
        );
    }

    function sample1() public view{
        vestingWallet.start();
    }
}
