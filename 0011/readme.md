## Introduction

In this task, you will implement a basic lending contract that allows users to stake their tokens and earn rewards over time. The contract will include a staking function, a withdrawal function, and a function to calculate rewards. The rewards will be calculated based on a constant annual reward rate of 5%.

## Objective

Your objective is to complete the implementation of the `StakingContract` smart contract. The contract should have the following features:

- A `stake` function that allows users to stake their tokens in the contract.
- A `withdraw` function that allows users to withdraw their staked tokens and any rewards they have earned.
- A `calculateReward` function that calculates the rewards a user has earned based on the amount of time they have staked their tokens.
- A constant annual reward rate of 5%.
- Rewards and staked amounts should be calculated separately to avoid compounding.

Pass the test will include the following scenarios:

- A user stakes tokens in the contract.
- A user withdraws tokens from the contract.
- The `calculateReward` function correctly calculates the rewards.
- The `stake` and `withdraw` functions correctly update the reward data.
- The contract correctly handles the case where a user tries to withdraw more tokens than they have staked.

## Hint

1. The contract will be implemented in Solidity and will use the ERC20 standard for the token. You will need to interact with the ERC20 token contract in your `StakingContract`. You can do this by importing the IERC20 interface from OpenZeppelin and initializing an IERC20 instance with the address of the token contract.

2. You will need to implement a `stake` function that allows users to stake their tokens in the contract. This function should first check that the user has approved the contract to spend their tokens. Then, it should transfer the tokens from the user to the contract and update the user's staked amount and the time they staked their tokens.

3. You will also need to implement a `withdraw` function that allows users to withdraw their staked tokens and any rewards they have earned. This function should first calculate the user's rewards, then transfer the staked tokens and rewards from the contract to the user, and finally update the user's staked amount and the time they staked their tokens.

4. The `calculateReward` function should calculate the rewards a user has earned based on the amount of time they have staked their tokens. You can calculate the rewards using the formula `stakedAmount * REWARD_RATE * timeElapsed / (365 days) / REWARD_RATE_DECIMAL`. The `timeElapsed` can be calculated as the current time minus the time the user staked their tokens.

5. The `stake` and `withdraw` functions should update the reward data whenever they are called. This means that you should call the `calculateReward` function at the beginning of these functions to calculate the user's rewards up to the current time, and then update the time the user staked their tokens to the current time.

6. Rewards and staked amounts should be calculated separately to avoid compounding. This means that you should not include the rewards in the staked amount when calculating the rewards. Instead, you should keep track of the staked amount and the rewards separately in the `Stake` struct.

## SideKnowledge

Staking is a common mechanism in decentralized finance (DeFi) that allows users to earn rewards by participating in a network. The rewards are usually paid out in the network's native token and can be a significant source of income for users. The annual reward rate is a common way to express the rate of return on staked tokens.