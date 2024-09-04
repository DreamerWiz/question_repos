## Introduction
In this task, you are given a `Logic` contract, a `Proxy` contract, and an `Attack` contract. The `Logic` contract is the implementation contract that contains the logic of the system. The `Proxy` contract delegates all calls to the `Logic` contract. The `Attack` contract is supposed to destroy the `Logic` contract.

## Objective
Your task is to modify the `Attack` contract to destroy the `Logic` contract. The `Attack` contract should take control over the `Logic` contract and upgrade the logic to a contract that selfdestructs once initialized.

## Hint
- The `Attack` contract can take control over the `Logic` contract by calling the `upgradeToAndCall` function of the `Logic` contract. This function upgrades the implementation of the proxy to a new implementation and subsequently executes a function call.
- To destroy the `Logic` contract, you can create a new contract that selfdestructs in its constructor or in its initializer function. This contract should have the same interface as the `Logic` contract. Then, you can upgrade the logic to this new contract.
- The `selfdestruct` function in Solidity destroys the contract and sends all remaining Ether in the contract to a specified address. After a contract is destroyed, its code is removed from the blockchain and it cannot be called anymore.

## Side Knowledge
- A proxy contract is a contract that delegates all calls to an implementation contract. The implementation contract contains the logic of the system. The proxy contract can change the address of the implementation contract to upgrade the system.
- The `delegatecall` function in Solidity is a low-level function that calls a function in another contract with the context of the calling contract. It is often used in proxy contracts to delegate calls to the implementation contract.
- The `selfdestruct` function in Solidity destroys the contract and sends all remaining Ether in the contract to a specified address. After a contract is destroyed, its code is removed from the blockchain and it cannot be called anymore.
- The `getCode` function in the Ethereum provider returns the bytecode of a contract. If the contract is destroyed, it returns an empty string.