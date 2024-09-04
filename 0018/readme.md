## Introduction
In this task, we have a `Target` contract that has a `protected` function. This function can only be called by an EOA (Externally Owned Account) and not by a contract. The `Target` contract uses the `extcodesize` assembly opcode to check if the caller is a contract. If the `extcodesize` of the caller is greater than 0, it means the caller is a contract and the function call is reverted.

## Objective
Your task is to create a `Hack` contract that can successfully call the `protected` function of the `Target` contract. You need to find a way to bypass the `isContract` check in the `Target` contract.

## Hint
- One way to bypass the `isContract` check is by using a delegatecall. A delegatecall is a special type of call where the code of the target contract is executed in the context of the calling contract. This means that the `msg.sender` in the `protected` function will be the original caller (the EOA), not the `Hack` contract.
- You can create a fallback function in the `Hack` contract that makes a delegatecall to the `Target` contract. Then, you can call this fallback function from an EOA to trigger the `protected` function in the `Target` contract.

## Side Knowledge
- `extcodesize` is an assembly opcode in Solidity that returns the size of the code at a given address. It can be used to check if an address is a contract or an EOA. Contracts will have a code size greater than 0, while EOAs will have a code size of 0.
- A delegatecall is a type of call in Solidity where the code of the target contract is executed in the context of the calling contract. This means that the storage, current address and balance of the calling contract are used for the call.