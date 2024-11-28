// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {BankAccountNFT} from "../src/practice/nft/BankAccountNFT.sol";

/// @custom:dev-run-script script/BankAccountNFTScript.s.sol
contract BankAccountNFTScript is Script {
    function run() external {
        // Start broadcasting transactions to the blockchain
        vm.startBroadcast();

        // Deploy the BankAccountNFT contract
        BankAccountNFT bankAccountNFT = new BankAccountNFT("Bank Account NFT", "BANK");

        console.log("Deployed BankAccountNFT contract at:", address(bankAccountNFT));

        vm.stopBroadcast();
    }
}