// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// Sould not be edited
contract NFT1 is ERC721URIStorage {
    uint256 public tokenCounter;

    constructor () ERC721("NFT1", "NFT1") {
        tokenCounter = 0;
    }

    function createCollectible(string memory tokenURI) public returns (uint256) {
        _safeMint(msg.sender, tokenCounter);
        _setTokenURI(tokenCounter, tokenURI);
        tokenCounter = tokenCounter + 1;
        return tokenCounter;
    }
}
// Sould not be edited
contract NFT2 is ERC721URIStorage {
    uint256 public tokenCounter;

    constructor () ERC721("NFT2", "NFT2") {
        tokenCounter = 0;
    }

    function createCollectible(string memory tokenURI) public returns (uint256) {
        _safeMint(msg.sender, tokenCounter);
        _setTokenURI(tokenCounter, tokenURI);
        tokenCounter = tokenCounter + 1;
        return tokenCounter;
    }
}