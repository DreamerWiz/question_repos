**Introduction**

In this task, we will complete a smart contract named `MyMintableNFT` that allows users to mint new Non-Fungible Tokens (NFTs). A unique feature of this contract is that users must pay a certain fee to mint new NFTs. We will also write a test script to ensure the contract functions as expected.

**Objective**

Complete the `createCollectible` function in the `MyMintableNFT` smart contract, enabling it to receive ETH and mint new NFTs.
Write a Hardhat test script that tests the following scenarios:
- A user attempts to mint a new NFT with insufficient funds, which should fail.
- A user mints a new NFT with sufficient funds, which should succeed.

**Hint**

- Use the `require` function to check if the ETH sent by the user is enough to cover the minting fee.
- Use the `_safeMint` and `_setTokenURI` functions to mint new NFTs.
- `tokenId` should starts with 0.

**SideKnowledge**

- Non-Fungible Tokens (NFTs) are a special type of blockchain token that represents ownership of a unique asset, such as artwork, collectibles, or virtual assets.
- ERC721 is a standard in Ethereum for creating NFTs. It defines a token interface that can be used to represent ownership of unique assets.
- Receiving ETH in smart contracts typically requires the use of the `payable` modifier. This modifier indicates that the function can receive ETH.
- In Solidity, the `require` function is used to check if a condition is true. If the condition is false, the function will immediately terminate and all state changes will be rolled back.