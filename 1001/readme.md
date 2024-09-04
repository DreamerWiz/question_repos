# ERC20 General Design Question

We need an ERC20 implementation to launch a new token with features involving timelock, claiming unlock token and public minting by eth.

- Must base on the `baseContract`.
- No other additional `.sol` imported

## Requirements I

Timelock should allow the owner to lock a certain amount of tokens for an address until a future block number.

- Only owner can mint and add timelock.
- Implementation should allow users to claim their unlocked tokens based on block numbers with `perBlockUnlockAmount = (totalLockedAmount - remainder) / (unlockedBlock - addTimeLockBlock)`.
- `remainder` should be claimed after the unlocked block number.
- If the owner adds timelock to an address more than twice, the tokens unlocked per block must be recalculated after every adding, and any already unlocked tokens should be retained for the user to claim.

### Example:

Let's assume the following scenario:

1. Token precision is `10**18` (standard for ERC-20 tokens).
2. Current block number is `100`.
3. We'll use the `addLockedMint` function twice for the same user.

At block `100`, we lock `1e18*101` (or `101` token with precision) for user `Alice` that will unlock at block `200`.

After this operation:
- `remainder` is `1e18 * 101 % (200 - 100)`
- `perBlockUnlockedAmount` for Alice: `( 1e18 * 101 - remainder) / (200 - 100) = 1e18` (1 token per block)

In this example, we've demonstrated how the token unlock mechanism works and how precision plays a role in the calculations. The user `Alice` can claim her tokens periodically, and the amount she can claim will depend on the number of blocks that have passed since the last update.

## Requirement II

We should implement the public minting function, let all user can buy this token by ETH.

Here are some rules for the public minting:

- The maximum publicMint limit is 5000 ETH.
- The limit per address is 2 ETH.
- Any excess ETH must be correctly returned to the user.
