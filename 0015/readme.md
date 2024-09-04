## Introduction

In this task, we will be working with three smart contracts: `Lib`, `HackMe`, and `Attack`. The `Lib` contract has a `pwn` function that allows anyone to change its `owner` state variable. The `HackMe` contract uses a delegate call to the `Lib` contract in its fallback function, which can lead to a security vulnerability. The `Attack` contract is designed to exploit this vulnerability and take over the ownership of the `HackMe` contract.

## Objective

The objective of this task is to implement the `attack` function in the `Attack` contract to exploit the security vulnerability in the `HackMe` contract and change its owner to the `Attack` contract. We will then write a Hardhat test script to verify that the `Attack` contract can successfully take over the ownership of the `HackMe` contract.

## Hint

1. The `Attack` contract can use the `call` function to trigger the fallback function of the `HackMe` contract. This will cause the `HackMe` contract to make a delegate call to the `Lib` contract.

2. Because the `HackMe` contract uses a delegate call to the `Lib` contract, the `Lib` contract's `pwn` function will execute in the context of the `HackMe` contract. This means it will change the `owner` state variable of the `HackMe` contract, not the `Lib` contract.

3. The `attack` function in the `Attack` contract should call the `pwn` function of the `Lib` contract. This can be done by calling the `HackMe` contract with the function signature of the `pwn` function.

## Side Knowledge

Delegate calls are a powerful feature in Solidity that allow a contract to execute code in the context of itself, but with the code taken from another contract. This means that while the code of the called contract is running, all state variables that it reads or writes to are in the calling contract, not the called contract. This can lead to security vulnerabilities if not used carefully, as it can allow an attacker to manipulate the state of the calling contract in unexpected ways.