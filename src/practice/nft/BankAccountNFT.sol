// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "lib/solmate/src/tokens/ERC721.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import "forge-std/console.sol";

error INSUFFICIENT_PAYMENT();
error NOTHING_TO_WITHDRAW();
error TOKEN_NOT_EXIST();

contract BankAccountNFT is ERC721, Ownable {
    using Strings for uint256;
    uint public currentTokenId;
    uint public constant MINT_PRICE = 1 ether;
    string public constant baseURI = "https://test.com/metadata/";

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) Ownable(msg.sender) {}

    function mintTo(address accountHolder) public payable returns (uint256) {
        if (msg.value != MINT_PRICE) {
            revert INSUFFICIENT_PAYMENT();
        }
        uint256 newTokenId = currentTokenId + 1;
        currentTokenId = newTokenId;
        _safeMint(accountHolder, newTokenId);
        // console.log("Minted to:", accountHolder);
        return newTokenId;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert TOKEN_NOT_EXIST();
        }
        return string(abi.encodePacked(baseURI, tokenId.toString()));
    }

    function withdrawPayments(address payable payee) external onlyOwner {
        // console.log("got in");
        // console.log("owner:", owner());
        // console.log("msg.sender:", msg.sender);
        // console.log('balance:', address(this).balance);
        if (address(this).balance == 0) {
            revert NOTHING_TO_WITHDRAW();
        }
        payable(payee).transfer(address(this).balance);
    }

    function _checkOwner() internal view override {
        require(msg.sender == owner(), "Ownable: caller is not the owner");
    }
}
