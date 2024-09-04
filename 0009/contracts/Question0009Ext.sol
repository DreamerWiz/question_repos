// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyERC721 is ERC721 {
    uint256 public constant MINTING_FEE = 0.01 ether;
    uint256 public nextTokenId = 0;

    constructor() ERC721("MyERC721", "ME721") {}

    function mintItem() public payable {
        require(msg.value >= MINTING_FEE, "Insufficient minting fee");
        _mint(msg.sender, nextTokenId);
        nextTokenId++;
    }
}