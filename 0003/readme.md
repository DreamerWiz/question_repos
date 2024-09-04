## Introduction

In this task, we will complete a smart contract named MyToken. This contract allows the owner to mint new ERC20 tokens. The unique feature of this contract is that it burns 15% of the tokens during each transfer operation. We will also write a test script to ensure the contract functions correctly.

## Objective

Complete the MyToken smart contract, enabling it to mint new tokens and burn 15% of the tokens during each transfer operation.
Pass a Hardhat test script that tests the following scenarios:
- The contract owner mints new tokens.
- A user transfers tokens to another user, and 15% of the tokens are burned during the transfer.
- A user approves another user to spend their tokens, and the approved user transfers the tokens. Again, 15% of the tokens are burned during the transfer.

## Hint

Use the `_burn(address, amount)` function to burn tokens.
Override the `_transfer` function to burn 15% of the tokens during each transfer operation.
Use the `approve` and `transferFrom` functions to test the scenario where a user approves another user to spend their tokens.

## SideKnowledge

ERC20 is a standard interface for tokens on the Ethereum blockchain. It includes basic functionality to transfer tokens, as well as allow tokens to be approved so they can be spent by another on-chain third party.
In Solidity, you can override functions (inherited from parent contracts) to change their behavior. However, you must include the `override` keyword in the function signature, and the new function must have the same name and type as the parent function.
Burning tokens is a way of permanently removing tokens from circulation, which can be used to reduce the total supply of tokens.