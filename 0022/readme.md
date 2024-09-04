## Introduction
In this task, you are given a `Wallet` contract and an `Attack` contract. The `Wallet` contract has a `transfer` function that only allows the owner of the contract to transfer Ether from the contract. The `Attack` contract is supposed to steal all Ether from the `Wallet` contract.

## Objective
Your task is to modify the `Wallet` contract to prevent the `Attack` contract from stealing Ether. The `Attack` contract tries to steal Ether by calling the `transfer` function of the `Wallet` contract.

## Hint
- The `Wallet` contract uses `tx.origin` to check if the caller is the owner of the contract. However, `tx.origin` refers to the original sender of the transaction, which is the address of the externally owned account (EOA) that started the transaction, not the contract that is currently executing. Therefore, if a contract function is called by another contract, `tx.origin` will be the address of the EOA, not the address of the calling contract.
- To prevent the `Attack` contract from stealing Ether, you can change the `require` statement in the `transfer` function to check if `msg.sender` is the owner of the contract, instead of `tx.origin`. `msg.sender` is the address of the contract that is currently executing, so it will be the address of the `Attack` contract when the `transfer` function is called by the `Attack` contract.

## Side Knowledge
- `tx.origin` and `msg.sender` are global variables in Solidity that provide information about the sender of the transaction. `tx.origin` is the address of the EOA that started the transaction, while `msg.sender` is the address of the contract that is currently executing.
- `call` is a low-level function in Solidity that is used to call another contract. It takes an optional Ether value and a data payload, and returns a boolean indicating whether the call was successful, and a data payload. It is often used to interact with contracts that do not have a known interface.
- A `require` statement in Solidity checks a condition, and if the condition is not met, it reverts the transaction and undoes all changes to the state. It is often used to check input parameters and state conditions.