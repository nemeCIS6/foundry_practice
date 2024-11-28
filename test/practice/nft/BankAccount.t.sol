// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, stdStorage, StdStorage} from "forge-std/Test.sol";
import "../../../src/practice/nft/BankAccountNFT.sol";

contract BankAccountNFTTest is Test {
    using stdStorage for StdStorage;

    BankAccountNFT private bankAccountNFT;
    address public account1 =
        address(0x1234567890123456789012345678901234567891);
    address public account2 =
        address(0x1234567890123456789012345678901234567892);

    function setUp() public {
        bankAccountNFT = new BankAccountNFT("Bank Account", "BANFT");
    }

    function test_MintFail() public {
        vm.expectRevert(INSUFFICIENT_PAYMENT.selector);
        bankAccountNFT.mintTo(account1);
    }

    function test_MintSuccess() public {
        bankAccountNFT.mintTo{value: 1 ether}(account1);
    }

    function test_withdrawPaymentsFail() public {
        bankAccountNFT.mintTo{value: 1 ether}(account1);
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(account2);
        bankAccountNFT.withdrawPayments(payable(account2));
        vm.stopPrank();
    }

    function test_withdrawPaymentsNothingToWithdraw() public {
        vm.expectRevert(NOTHING_TO_WITHDRAW.selector);
        bankAccountNFT.withdrawPayments(payable(account1));
    }

    function test_withdrawPaymentsSuccess() public {
        bankAccountNFT.mintTo{value: 1 ether}(account2);
        bankAccountNFT.withdrawPayments(payable(account1));
        assertEq(0,address(bankAccountNFT).balance);
    }
}
