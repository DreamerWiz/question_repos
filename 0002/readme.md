## Introduction

In this task, we will complete a smart contract named MyToken. This contract is an implementation of the ERC20 standard with an additional time lock feature. The contract allows the owner to mint new tokens and add a time lock to an address, preventing the address from transferring its tokens until the time lock has expired. 

## Objective

Complete the MyToken smart contract, enabling it to mint new tokens, add time locks to addresses, and handle token transfers according to the time locks. 

Pass a Hardhat test script that tests the following scenarios:

- The owner mints new tokens to an address.
- A non-owner address fails to mint new tokens.
- The owner adds a time lock to an address.
- A non-owner address fails to add a time lock.
- An address with a time lock fails to transfer its tokens.
- After the time lock has expired, the address successfully transfers its tokens.

## Hint

Use the `require` function to check if an address's tokens are locked when it tries to transfer tokens.

## SideKnowledge

ERC20 is a standard interface for fungible tokens, meaning each token is identical to every other token; this is why they are called fungible. 

Time locks are a feature that can be added to a contract to restrict an address's ability to transfer its tokens until a certain time has passed. 

In Solidity, the `onlyOwner` modifier is used to restrict a function to the contract owner. 

In a Hardhat test script, the `evm_increaseTime` function can be used to simulate the passing of time in the blockchain.