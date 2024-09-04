## Introduction

In this task, we will create a simple NFT exchange contract named NFTExchange. This contract will allow users to safely exchange their NFTs with each other in a two-step process: proposing a trade and executing a trade. We will also create two simple NFT contracts named NFT1 and NFT2 for demonstration purposes. Finally, we will write a test script to ensure the exchange contract functions correctly.

## Objective

Complete the NFTExchange smart contract, enabling it to facilitate the exchange of NFTs between users in a two-step process.
Complete the NFT1 and NFT2 smart contracts, enabling users to mint new NFTs.
Answer should pass a Hardhat testing script that tests the following scenarios:
User A mints a new NFT from the NFT1 contract.
User B mints a new NFT from the NFT2 contract.
User A proposes a trade with User B.
User B executes the trade with User A.
The ownership of the NFTs has been swapped between User A and User B.

## Hint
Use the IERC721 interface to interact with the NFT contracts.
Use the safeTransferFrom function to transfer NFTs between users.
Use events to retrieve the trade ID from the transaction receipt.

## SideKnowledge

Non-Fungible Tokens (NFTs) are a special type of blockchain token that represents ownership of a unique asset, such as artwork, collectibles, or virtual assets.
ERC721 is a standard in Ethereum for creating NFTs. It defines a token interface that can be used to represent ownership of unique assets.
In Solidity, you can use the IERC721 interface to interact with any contract that implements the ERC721 standard. This includes functions for transferring tokens, checking the balance of an address, and checking the owner of a token.
Events in Solidity are a way for your contract to communicate that something has happened to the external world. They are also capable of returning the result of a transaction, which can be useful when you want to retrieve the result of a function execution.