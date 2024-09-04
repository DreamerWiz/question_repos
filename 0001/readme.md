**Introduction**

In this task, we will create a simple ERC20 token contract named `MyToken`. This contract will allow the contract deployer (owner) to mint new tokens. We will also pass a test script to ensure the contract functions correctly.

**Objective**

- Complete the `MyToken` smart contract, enabling the contract deployer to mint new tokens.
- Pass a Hardhat test script that tests the following scenarios:
  - The contract deployer mints new tokens to a user.
  - A user who is not the contract deployer attempts to mint new tokens, which should fail.
  - The user transfers some of the tokens to another user.
  - The user approves another user to spend some of their tokens.
  - A user transfers some of the approved tokens to a third user.

**Hint**

- Use the `ERC20` contract from the OpenZeppelin library as a base for the `MyToken` contract.
- Use the `_mint` function to mint new tokens.
- Use the `transfer` and `approve` functions to transfer tokens and approve another user to spend tokens.
- Use the `transferFrom` function to transfer approved tokens from one user to another.
- Use the `onlyOwner` modifier to restrict the minting of new tokens to the contract deployer.

**SideKnowledge**

- ERC20 is a standard in Ethereum for creating fungible tokens. It defines a token interface that can be used to represent assets that have equal value to each other, like currencies or voting rights.
- The OpenZeppelin library is a secure and community-audited library for Ethereum smart contract development. It provides implementations of standards like ERC20 and ERC721 which you can deploy as-is or extend to suit your needs.
- In Solidity, you can use the `onlyOwner` modifier to restrict certain functions to the contract deployer. This can be useful for administrative tasks like minting new tokens.
- The `transferFrom` function in ERC20 allows a user to transfer tokens that have been approved for them by another user. This can be used to implement "allowance" systems where one user can spend tokens on behalf of another.