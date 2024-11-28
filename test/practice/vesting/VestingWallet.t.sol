// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../src/practice/vesting/VestingWallet.sol";
import {VestingToken} from "../../../src/practice/vesting/VestingToken.sol";

contract VestingWalletTest is Test{
    VestingWallet public vestingWallet;
    VestingToken public vestingToken;
    address user1 = address(1);

    function setUp() public{
        vestingWallet = new VestingWallet(
            user1,
            1732785200,
            3600
        );

        vestingToken = new VestingToken(
            1000000
        );
    }

    function test_VestedAmountBeforeFunding() public view{
        assertEq(vestingWallet.vestedAmount(uint64(block.timestamp)),0);
        assertEq(vestingWallet.vestedAmount(address(vestingToken),uint64(block.timestamp)),0);
    }

    function test_fundVestingContractWithEther() external {
        vm.deal(address(vestingWallet), 1 ether);
        console.log("coin balance:",address(vestingWallet).balance);
        assertEq(address(vestingWallet).balance,1 ether);
        deal(address(vestingToken),address(vestingWallet),10000e18);
        assertEq(IERC20(vestingToken).balanceOf(address(vestingWallet)),10000e18);
    }
}
