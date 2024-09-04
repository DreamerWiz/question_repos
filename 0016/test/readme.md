## Introduction
In this task, we will create a contract called `EighthIsWinner` where the 8th times to deposit 1 Ether wins the game and gets all assets in the contract. However, there is a vulnerability in this contract that allows an attacker to forcibly send ethers to this contract using `selfdestruct` method, which can disrupt the game. 

## Objective
Your task is to understand the vulnerability and modify the `EighthIsWinner` contract to make it secure. The contract should only accept deposits through the `deposit` function and reject any ethers sent to it forcibly. 

Pass a Hardhat test script that tests the following scenarios:
- The `EighthIsWinner` contract correctly identifies the 8th depositor as the winner.
- The `EighthIsWinner` contract rejects an attack where an attacker forcibly sends ethers to it.
- The winner can claim the reward and the balance of the contract is 0 after the reward is claimed.

## Hint
- To prevent ethers from being forcibly sent to the contract, you can use the `fallback` function to reject any ethers sent to it. The `fallback` function is called when the contract receives Ether without a function being explicitly called.
- To check if the contract is secure, you can deploy an `Attack` contract that tries to forcibly send ethers to the `EighthIsWinner` contract. If the attack fails and the game proceeds as expected, then the contract is secure.

## Side Knowledge
- The `selfdestruct` function in Solidity can be used to destroy a contract and send its funds to another address. However, it can also be used to forcibly send ethers to a contract, which can disrupt its logic.
- The `fallback` function in Solidity is a special function that is executed when the contract receives Ether without a function being explicitly called. It can be used to reject any ethers sent to the contract.