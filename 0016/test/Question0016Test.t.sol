// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0016Solution.sol";

contract Question1006Test is Test {
    EighthIsWinner private eighthIsWinner;
    Question0016Solution private attack;
    address private deployerAddress;
    address private attackerAddress;
    address private user1Address;
    address private user2Address;

    string constant FILE_NAME = "test/Question0016Test.t.sol.passed";

    function setUp() public {
        // Deploy the EighthIsWinner contract
        eighthIsWinner = new EighthIsWinner();

        // Deploy the Question0016Solution contract with the address of the EighthIsWinner contract
        attack = new Question0016Solution(eighthIsWinner);

        // Assign the addresses for deployer, attacker, and users
        deployerAddress = vm.addr(1);
        attackerAddress = vm.addr(2);
        user1Address = vm.addr(3);
        user2Address = vm.addr(4);
        vm.deal(attackerAddress, 10 ether);
        // Simulate deposits from two different users
        vm.deal(user1Address, 10 ether);
        vm.startPrank(user1Address);
        eighthIsWinner.deposit{value: 1 ether}();
        vm.stopPrank();

        vm.deal(user2Address, 10 ether);
        vm.startPrank(user2Address);
        eighthIsWinner.deposit{value: 1 ether}();
        vm.stopPrank();
    }

    function test_Initial_Balance_Is_2_ETH() public {
        // Assert initial balance is 2 ETH
        assertEq(eighthIsWinner.getBalance(), 2 ether, "Initial balance should be 2 ETH");

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Initial_Balance_Is_2_ETH");
    }

    function test_Attacker_Should_Not_Break_Contract() public {
        // Simulate the attack from the attacker's perspective
        vm.startPrank(attackerAddress);

        // Perform the attack
        attack.attack{value: 7 ether}();
        vm.stopPrank();

        // Simulate the user depositing 6 times
        vm.startPrank(user1Address);
        for (uint256 i = 0; i < 6; i++) {
            eighthIsWinner.deposit{value: 1 ether}();
        }

        // Check if the winner is user1
        assertEq(eighthIsWinner.getWinner(), user1Address, "User1 should be the winner");

        // Claim the reward
        eighthIsWinner.claimReward();

        // Assert that the winner has received the reward
        assertLe(eighthIsWinner.getBalance(), 7 ether, "Winner should have claimed the reward");

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Attacker_Should_Not_Break_Contract");
    }
}
