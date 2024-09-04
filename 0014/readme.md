## Introduction

In this task, we will be working with a smart contract named `DecentralizedBanktoAttackFixChallenge`. This contract allows users to deposit Ether and withdraw it. However, there is a potential security vulnerability in the contract that could allow an attacker to drain all the funds from the contract. We will also be working with an `Attack` contract that is designed to exploit this vulnerability.

## Objective

The objective of this task is to modify the `DecentralizedBanktoAttackFixChallenge` contract to fix the security vulnerability and prevent the `Attack` contract from draining its funds. We will then write a Hardhat test script to verify that the `DecentralizedBanktoAttackFixChallenge` contract is secure and that the `Attack` contract is unable to drain its funds.

## Hint

1. The `Attack` contract uses a fallback function to recursively call the `withdraw` function of the `DecentralizedBanktoAttackFixChallenge` contract. This is a common reentrancy attack pattern. To prevent this, the `DecentralizedBanktoAttackFixChallenge` contract should update the user's balance before sending the Ether.

2. The `Attack` contract's `attack` function sends 1 Ether to the `DecentralizedBanktoAttackFixChallenge` contract and then calls its `withdraw` function. To prevent this attack, the `DecentralizedBanktoAttackFixChallenge` contract should use the `reentrancy guard` pattern, which prevents nested calls to its functions.

3. The `DecentralizedBanktoAttackFixChallenge` contract should use the `pull over push` pattern for sending Ether. This means it should allow users to withdraw their funds themselves, rather than pushing the funds to their addresses. This can prevent a variety of attacks, including reentrancy attacks.

4. The `DecentralizedBanktoAttackFixChallenge` contract should also include checks to ensure that users cannot withdraw more Ether than they have deposited.

## Side Knowledge

Reentrancy attacks are a common security vulnerability in smart contracts. They occur when a contract's function calls an external contract before it resolves its effects. If the called contract then calls back into the calling contract before the first function call is finished, the calling contract's state may be manipulated in unexpected ways. To prevent reentrancy attacks, contracts should make external calls last in any function, after all changes to the contract's state have been made.