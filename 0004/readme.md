**Introduction**

In this task, we will complete a smart contract named `MyRefundableMintableNFT`. This contract allows users to pay a certain fee to mint new Non-Fungible Tokens (NFTs). If the user pays more than the required minting fee, the excess amount will be refunded. We will also write a test script to ensure the contract functions correctly.

**Objective**

Complete the `createCollectible` function in the `MyRefundableMintableNFT` smart contract, enabling it to receive ETH, mint new NFTs, and refund any excess payment.
Pass a Hardhat test script that tests the following scenarios:
- A user tries to mint a new NFT with insufficient funds, which should fail.
- A user mints a new NFT with sufficient funds, which should succeed.
- A user mints a new NFT with more than the required funds, which should succeed, and the excess funds should be refunded.
- After minting a new NFT, the owner of the NFT should be checked.
- After minting a new NFT, it should be checked whether the contract deployer has received the minting fee.

**Hint**

- Use the `require` function to check if the ETH sent by the user is enough to pay the minting fee.
- Use the `_safeMint` and `_setTokenURI` functions to mint new NFTs.
- Use the `msg.sender.transfer` function to refund any excess payment.

**SideKnowledge**

- Non-Fungible Tokens (NFTs) are a special type of blockchain token that represents ownership of a unique asset, such as artwork, collectibles, or virtual assets.
- ERC721 is a standard in Ethereum for creating NFTs. It defines a token interface that can be used to represent ownership of unique assets.
- In Ethereum, each transaction requires the payment of a certain amount of gas. Gas is used to reward miners for processing transactions and maintaining the network.
- In Solidity, you can use `msg.value` to get the amount of ETH paid to a function. You can also use `msg.sender.transfer` to send ETH to the address of `msg.sender`.