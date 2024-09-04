## Introduction
In this task, we will create two smart contracts: `MyERC721` and `MyERC1155`. The `MyERC721` contract allows users to mint new ERC721 tokens by paying a certain fee. The `MyERC1155` contract allows users to mint new ERC1155 tokens, but only if they already own a specific `MyERC721` token, and each `MyERC721` token can only be used to mint a `MyERC1155` token once.

## Objective
Complete the `mintItem` functions in the `MyERC721` and `MyERC1155` smart contracts, enabling them to mint new ERC721 and ERC1155 tokens, respectively.

Write a Hardhat test script that tests the following scenarios:
- A user mints a new ERC721 token, which should succeed.
- The same user mints a new ERC1155 token using the ERC721 token, which should succeed.
- The same user tries to mint another ERC1155 token with the same ERC721 token and fails.
- A different user tries to mint a new ERC1155 token and fails because they do not own the corresponding ERC721 token.

## Hint
- Use the `_mint` function to mint new ERC721 and ERC1155 tokens.
- Use the `ownerOf` function to check if a user owns a specific ERC721 token.
- Use a mapping to keep track of which ERC721 tokens have been used to mint ERC1155 tokens.

## Side Knowledge
- ERC721 is a standard in Ethereum for creating non-fungible tokens (NFTs), i.e., tokens that are unique and not interchangeable.
- ERC1155 is a standard in Ethereum for creating multi-token contracts, i.e., contracts that can handle multiple tokens at once. It combines the capabilities of ERC20 (fungible tokens) and ERC721 (non-fungible tokens).