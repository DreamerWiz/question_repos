## Introduction

In this task, we will create a non-transferable NFT contract named MyNonTransferableNFT. This contract will allow users to mint new NFTs, but once minted, these NFTs cannot be transferred to another address. This is a unique feature that differentiates MyNonTransferableNFT from traditional NFTs, which are typically transferable.

## Objective

Complete the MyNonTransferableNFT smart contract, enabling users to mint new NFTs that cannot be transferred.
Write a Hardhat test script that tests the following scenarios:
User A mints a new NFT.
User A attempts to transfer the NFT to User B, which should fail.
The ownership of the NFT remains with User A.

## Hint

Use the ERC721 contract from the OpenZeppelin library as a base for the MyNonTransferableNFT contract.
Override the transferFrom and safeTransferFrom functions to prevent NFTs from being transferred.
Use the _safeMint function to mint new NFTs.

## SideKnowledge

Non-Fungible Tokens (NFTs) are a special type of blockchain token that represents ownership of a unique asset, such as artwork, collectibles, or virtual assets.
ERC721 is a standard in Ethereum for creating NFTs. It defines a token interface that can be used to represent ownership of unique assets.
The OpenZeppelin library is a secure and community-audited library for Ethereum smart contract development. It provides implementations of standards like ERC20 and ERC721 which you can deploy as-is or extend to suit your needs.
In Solidity, you can override functions (change their behavior) in derived contracts. In this case, we override the transferFrom and safeTransferFrom functions to prevent NFTs from being transferred.