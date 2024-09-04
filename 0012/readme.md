## Introduction
In this task, we will create a DAO (Decentralized Autonomous Organization) contract that allows the owner to approve and execute proposals. Each proposal is a contract that has an `executeProposal` function. However, there is a vulnerability in the DAO contract that allows an attacker to execute malicious code.

## Objective
Your task is to understand the vulnerability and write a contract that exploits it. The attack contract should change the owner of the DAO contract to the attacker's address.

Write a Hardhat test script that tests the following scenarios:
- The DAO contract approves a proposal.
- The DAO contract executes the approved proposal, which should succeed.
- The attacker deploys the attack contract.
- The DAO contract tries to execute the proposal again, but this time it executes the malicious code in the attack contract, which changes the owner of the DAO contract to the attacker's address.

## Hint
- The vulnerability lies in the `execute` function of the DAO contract. It uses `delegatecall` to call the `executeProposal` function of the proposal contract. However, `delegatecall` executes the code in the context of the calling contract (DAO contract in this case), so it can change the state variables of the DAO contract.
- To exploit this vulnerability, the attack contract should implement an `executeProposal` function that changes the owner of the DAO contract.
- The attacker can make the DAO contract execute the malicious code by making sure the address of the attack contract is the same as the address of the approved proposal. This can be achieved by using the same salt for deploying the proposal and the attack contract.

## Side Knowledge
- `delegatecall` is a low-level function in Solidity that calls a function in another contract but executes the code in the context of the calling contract. This means it can change the state variables of the calling contract.
- A salt is a random value that is used in the `CREATE2` opcode to create a contract at a deterministic address. The address of the contract is determined by the deployer's address, the bytecode of the contract, and the salt.