## Introduction
In this task, we will create a contract that can attack a vulnerable Decentralized Bank contract. The Decentralized Bank contract allows users to deposit and withdraw Ether, but it has a vulnerability in the `withdraw` function that allows an attacker to drain all the Ether from the contract.

## Objective
Your task is to understand the vulnerability and write an `AttackChallenge` contract that exploits it. The `AttackChallenge` contract should have an `attack` function that drains all the Ether from the `DecentralizedBanktoAttack` contract.

Write a Hardhat test script that tests the following scenarios:
- The `DecentralizedBanktoAttack` contract has 10 Ether.
- The `AttackChallenge` contract calls the `attack` function and drains all the Ether from the `DecentralizedBanktoAttack` contract.

## Hint
- The vulnerability lies in the `withdraw` function of the `DecentralizedBanktoAttack` contract. It uses `call` to send Ether to the user, but `call` is vulnerable to reentrancy attacks. This means that the `fallback` function of the `AttackChallenge` contract can call the `withdraw` function again before the `balances[msg.sender] = 0;` line is executed.
- To exploit this vulnerability, the `AttackChallenge` contract should have a payable `fallback` function that calls the `withdraw` function of the `DecentralizedBanktoAttack` contract. The `attack` function should deposit some Ether to the `DecentralizedBanktoAttack` contract and then call the `withdraw` function.

## Side Knowledge
- A reentrancy attack is a type of vulnerability in smart contracts where a function can be re-entered before it is finished. This can lead to unexpected behavior, such as funds being withdrawn multiple times.
- The `call` function in Solidity is a low-level function that sends Ether and executes code in another contract. It is vulnerable to reentrancy attacks because it hands over control to the called contract before the function is finished.