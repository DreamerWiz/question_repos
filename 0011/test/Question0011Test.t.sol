// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0011Ext.sol"; // Update this import path to your contract's location
import "../contracts/Question0011Solution.sol"; // Update this import path to your contract's location

contract Question0011Test is Test {
    string constant FILE_NAME = "test/Question0011Test.t.sol.passed";
    MyToken token;
    StakingContract stakingContract;
    address owner;
    address addr1;
    address addr2;

    function setUp() public {
        token = new MyToken("MyToken", "MT");
        stakingContract = new StakingContract(IERC20(token));
        
        owner = makeAddr("owner");
        addr1 = makeAddr("addr1");
        addr2 = makeAddr("addr2");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Should mint and stake tokens correctly
        @Desc: Test to ensure that tokens can be minted and staked correctly.
    */
    function test_Should_mint_and_stake_correctly() public {
        // Owner mints 1000 tokens to addr1
        token.mint(addr1, 1000);
        assertEq(token.balanceOf(addr1), 1000);

        // Addr1 stakes 500 tokens
        vm.prank(addr1);
        token.approve(address(stakingContract), 500);
        vm.prank(addr1);
        stakingContract.stake(500);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Should_mint_and_stake_correctly passed");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Should calculate rewards correctly
        @Desc: Test to ensure that staking rewards are calculated correctly.
    */
    function test_Should_calculate_rewards_correctly() public {
        // Owner mints 1000 tokens to addr1 and addr1 stakes 500 tokens
        setupStake(addr1, 1000, 500);

        // Advance time by 100 days
        vm.warp(block.timestamp + 100 days);

        uint256 e = uint256(500) * 5 / 100 * 100 / 365;
        // Check the reward for addr1
        uint256 reward = stakingContract.calculateReward(addr1);
        assertEq(reward, e);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Should_calculate_rewards_correctly passed");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Should withdraw staked tokens correctly
        @Desc: Test to ensure that staked tokens can be withdrawn correctly along with the rewards.
    */
    function test_Should_withdraw_correctly() public {
        // Owner mints 1000 tokens to addr1 and addr1 stakes 500 tokens
        setupStake(addr1, 1000, 500);

        // Advance time by 100 days
        vm.warp(block.timestamp + 100 days);

        // Calculate the expected reward
        uint256 expectedReward = uint256(500 * 5 * 100) / 36500;

        // Addr1 withdraws 250 tokens
        vm.prank(addr1);
        stakingContract.withdraw(250);

        // Calculate the expected final balance of addr1 (original balance - staked amount + withdrawn amount + reward)
        uint256 expectedFinalBalance = (1000 - 500) + 250 + expectedReward;

        // Check the final balance for addr1
        uint256 finalBalance = token.balanceOf(addr1);
        assertEq(finalBalance, expectedFinalBalance);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Should_withdraw_correctly passed");
    }

    // Helper function to setup stake
    function setupStake(address _addr, uint256 _mintAmount, uint256 _stakeAmount) internal {
        token.mint(_addr, _mintAmount);
        assertEq(token.balanceOf(_addr), _mintAmount);

        vm.prank(_addr);
        token.approve(address(stakingContract), _stakeAmount);
        vm.prank(_addr);
        stakingContract.stake(_stakeAmount);
    }

}
