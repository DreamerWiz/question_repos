## Introduction
In this task, you are given a `MultiSigWallet` contract. This contract allows transferring funds only if the transaction is signed by both owners. The contract uses the ECDSA library from OpenZeppelin to recover the signer from the signatures.

## Objective
Your task is to ensure the security of the `MultiSigWallet` contract. You need to prevent any potential attacks that could exploit the contract's vulnerabilities and steal the funds.

## Hint
- One potential vulnerability is the lack of nonce validation. The contract checks the signatures against a transaction hash that includes a nonce, but it doesn't check if the nonce is used only once. This could allow an attacker to replay a transaction.
- To fix this vulnerability, you could keep track of used nonces in a mapping and check if a nonce is used before processing a transaction. If the nonce is used, the function call should be reverted.

## Side Knowledge
- ECDSA (Elliptic Curve Digital Signature Algorithm) is a cryptographic algorithm used by Ethereum for generating and verifying signatures. It allows someone to verify the signer of a message without knowing the signer's private key.
- A nonce is a number that is used only once. In Ethereum, nonces are used to prevent replay attacks. Each transaction from an account must have a unique nonce. The nonce starts from 0 and is incremented by 1 for each subsequent transaction.