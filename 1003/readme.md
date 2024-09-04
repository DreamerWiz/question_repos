# EthMonster: A Blockchain-based Adventure Game

## Introduction
EthMonster is an enthralling blockchain-based game built on the robust Ethereum blockchain. Utilizing the ERC-721 standard, EthMonster allows players to mint, own, and interact with unique digital monsters on their quest to conquer various villages. Each monster is a distinct ERC-721 token with specific traits and capabilities.

## Requirements
You can only inherit from ethMonsterBase below:
```c#
abstract contract EthMonsterBase is ERC721 {
    constructor() ERC721("EthMonster", "EMON") {}

    function mintMonster() external payable virtual;

    function sendOnRaid(uint256 monsterId, uint256 blocks) external virtual;

    function claimRaid(uint256 monsterId) external virtual;

    function levelUp(uint256 monsterId) external payable virtual;

    function abandonMonster(uint256 monsterId) external virtual;

    function recallMonster(uint256 monsterId) external virtual;

    function isOnRaid(uint256 monsterId) external view virtual returns (bool);

    function isAbandoned(
        uint256 monsterId
    ) external view virtual returns (bool);

    function getLevel(
        uint256 monsterId
    ) external view virtual returns (uint256);

    function getExp(uint256 monsterId) external view virtual returns (uint256);
}
```

## Features

1. **ERC-721 Compliance**:
   - EthMonster is primarily an ERC-721 contract ensuring each monster is a unique, non-fungible token with individual ownership.
   - Monster ID should start with 1.

2. **Free Monster Minting**:
   - Players can mint their own monsters at 1 ether cost, kickstarting their adventure in the EthMonster realm.

3. **Leveling System**:
   - Monsters start at level 1 and can earn experience points (XP) by raiding villages.
   - The experience needed for leveling up is calculated as $100 * 2^{level}$.
   - Leveling up requires a payment of $0.1 * 2^{level}$ ether.

4. **Village Raids**:
   - Monsters can be sent on raids to nearby villages to earn experience and ether.
   - Each block earns the monster $10 * {level} * {raidPassedBlocks}$ XP and an ether reward based on $0.0001 * 2^{level-1}$.
   - The number of blocks for a raid is specified by the player and monsters cannot perform other actions until the raid is complete.

5. **Recalling Monsters**:
   - Monsters can be recalled by their owners at any time.
   - If a raid is incomplete upon recalling, no rewards are given.

6. **Monster Abandonment**:
   - Owners can choose to abandon their monsters.
   - Upon abandonment, half of the ether spent on the previous level upgrade is refunded and the monster is destroyed.
