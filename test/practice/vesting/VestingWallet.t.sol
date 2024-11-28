// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../src/practice/vesting/VestingWallet.sol";
import {VestingToken} from "../../../src/practice/vesting/VestingToken.sol";

contract VestingWalletTest is Test {
    VestingWallet public vestingWallet;
    VestingToken public vestingToken;
    address user1 = address(1);
    uint256 startTimestamp = block.timestamp;

    function setUp() public {
        vestingWallet = new VestingWallet(user1, 0, 3600);

        vestingToken = new VestingToken(1000000);
    }

    function test_VestedAmountBeforeFunding() public view {
        assertEq(vestingWallet.vestedAmount(uint64(block.timestamp)), 0);
        assertEq(
            vestingWallet.vestedAmount(
                address(vestingToken),
                uint64(block.timestamp)
            ),
            0
        );
    }

    function test_fundVestingContractWithEther() external {
        vm.deal(address(vestingWallet), 1 ether);
        console.log("coin balance:", address(vestingWallet).balance);
        assertEq(address(vestingWallet).balance, 1 ether);
        deal(address(vestingToken), address(vestingWallet), 10000e18);
        assertEq(
            IERC20(vestingToken).balanceOf(address(vestingWallet)),
            10000e18
        );
    }

    function test_lapsedReleasedOnce() external {
        deal(address(vestingToken), address(vestingWallet), 10000e18);
        vm.warp(3601);
        console.log("block timestamp:", block.timestamp);
        uint256 vestedAmount = vestingWallet.vestedAmount(
            address(vestingToken),
            uint64(block.timestamp)
        );
        console.log("vestedAmount:", vestedAmount);
        assertEq(10000e18, vestedAmount);
    }

    function test_interval() external {
        vm.deal(address(vestingWallet), 10000 ether);
        uint256 intervals = vestingWallet.duration() /
            vestingWallet.intervalInSecs();
        for (uint256 i = 0; i < intervals; i++) {
            vm.warp(180 * (i+1));
            console.log("block timestamp:", block.timestamp);
            uint256 vestedAmount = vestingWallet.vestedAmount(
                uint64(block.timestamp)
            );
            console.log("vestedAmount:", vestedAmount / 1 ether);
            console.log("expectedVestedAmount:", ((10000 ether / intervals)*(i+1))/1 ether);
            console.log("--------------------------------------");
            assertEq((10000 ether / intervals)*(i+1), vestedAmount);
        }
    }

    function test_intervalWithSequentialReleaseEther() external {
        vm.deal(address(vestingWallet), 10000 ether);
        uint256 intervals = vestingWallet.duration() /
            vestingWallet.intervalInSecs();
        uint256 startTime = vestingWallet.start();
        console.log("--------------------------------------");
        vestingWallet.release();
        console.log("--------------------------------------");
        for (uint256 i = 0; i < intervals; i++) {
            uint256 timestampWarp = startTime + vestingWallet.intervalInSecs() * (i+1);
            console.log("----------------","Interval:",i+1,"----------------");
            vm.warp(timestampWarp);
            vestingWallet.release();
            console.log("released:", vestingWallet.released() / 1 ether);
            assertEq((10000 ether / intervals)*(i+1), vestingWallet.released());
            //test interval no release
            console.log("-----test no release-----");
            vm.warp(timestampWarp+1);
            vestingWallet.release();
            console.log("released:", vestingWallet.released() / 1 ether);
            assertEq((10000 ether / intervals)*(i+1), vestingWallet.released());
            console.log("----------------------------------------------");
        }
    }

    function test_intervalWithSequentialReleaseERC20() external {
        deal(address(vestingToken), address(vestingWallet), 10000e18);
        uint256 intervals = vestingWallet.duration() /
            vestingWallet.intervalInSecs();
        uint256 startTime = vestingWallet.start();
        console.log("--------------------------------------");
        vestingWallet.release(address(vestingToken));
        console.log("--------------------------------------");
        for (uint256 i = 0; i < intervals; i++) {
            uint256 timestampWarp = startTime + vestingWallet.intervalInSecs() * (i+1);
            console.log("----------------","Interval:",i+1,"----------------");
            vm.warp(timestampWarp);
            vestingWallet.release(address(vestingToken));
            console.log("released:", vestingWallet.released(address(vestingToken)) / 1 ether);
            assertEq((10000e18 / intervals)*(i+1), vestingWallet.released(address(vestingToken)));
            //test interval no release
            console.log("-----test no release-----");
            vm.warp(timestampWarp+1);
            vestingWallet.release(address(vestingToken));
            console.log("released:", vestingWallet.released(address(vestingToken)) / 1 ether);
            assertEq((10000e18 / intervals)*(i+1), vestingWallet.released(address(vestingToken)));
            console.log("----------------------------------------------");
        }
    }
}
