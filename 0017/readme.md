## Introduction
In this task, we will create a contract called `GameOfEther` where the person who pays more than the current balance becomes the winner. However, there is a vulnerability in this contract that allows an attacker to disrupt the game.

## Objective
Your task is to understand the vulnerability and modify the `GameOfEther` contract to make it secure. The contract should only accept payments through the `claimThrone` function and reject any ethers sent to it forcibly. 

Write a Hardhat test script that tests the following scenarios:
- The `GameOfEther` contract correctly identifies the person who pays more than the current balance as the winner.
- The `GameOfEther` contract rejects an attack where an attacker forcibly sends ethers to it.
- The winner can claim the reward and the balance of the contract is updated after the reward is claimed.

## Hint
- To prevent ethers from being forcibly sent to the contract, you can use the `fallback` function to reject any ethers sent to it. The `fallback` function is called when the contract receives Ether without a function being explicitly called.
- To check if the contract is secure, you can deploy a `GameOfEtherAttack` contract that tries to forcibly send ethers to the `GameOfEther` contract. If the attack fails and the game proceeds as expected, then the contract is secure.

## Side Knowledge
- The `call` function in Solidity can be used to send Ether and call a function on another contract. However, it can also be used to forcibly send ethers to a contract, which can disrupt its logic.
- The `fallback` function in Solidity is a special function that is executed when the contract receives Ether without a function being explicitly called. It can be used to reject any ethers sent to the contract.