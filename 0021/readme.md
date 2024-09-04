## Introduction
In this task, you are given a `NewCoin` contract which is an ERC20 token with a time lock feature. The time lock prevents a specific investor from transferring tokens until the time lock has passed. You are also given an `Attack` contract which is supposed to steal all tokens from the investor.

## Objective
Your task is to modify the `NewCoin` contract to prevent the `Attack` contract from stealing tokens from the investor. The `Attack` contract tries to steal tokens by calling the `transferFrom` function of the `NewCoin` contract. The investor has approved the `Attack` contract to spend all their tokens.

## Hint
- You can prevent the `Attack` contract from stealing tokens by adding the `timeLocker` modifier to the `transferFrom` function of the `NewCoin` contract. This will prevent the `Attack` contract from transferring tokens on behalf of the investor until the time lock has passed.
- The `transferFrom` function takes three arguments: the token owner's address, the recipient's address, and the amount of tokens to transfer. In this case, the token owner is the investor, the recipient is the `Attack` contract, and the amount is the investor's balance.

## Side Knowledge
- ERC20 is a standard interface for Ethereum tokens. It includes functions for transferring tokens, getting the balance of an account, and approving another account to spend tokens on behalf of the token owner.
- The `approve` function of an ERC20 token sets an allowance for a spender. The spender can then use the `transferFrom` function to spend up to the allowed amount of tokens on behalf of the token owner.
- A time lock is a mechanism that restricts the spending of tokens until a certain time has passed. It is often used in token sales to prevent early investors from selling their tokens immediately after the sale.