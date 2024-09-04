// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0017Solution.sol";
import "../contracts/Question0017Ext.sol";

contract Question0017Test is Test {
    Question0017Solution private gameOfEther;
    GameOfEtherAttack private attack;
    address private deployerAddress;
    address private attackerAddress;
    address private aliceAddress;

    string constant FILE_NAME = "test/Question0017Test.t.sol.passed";

    function setUp() public {
        // Deploy the GameOfEther contract
        gameOfEther = new Question0017Solution();

        // Deploy the GameOfEtherAttack contract with the address of the GameOfEther contract
        attack = new GameOfEtherAttack(gameOfEther);

        // Assign the addresses for deployer, attacker, and Alice
        deployerAddress = vm.addr(1);
        attackerAddress = vm.addr(2);
        aliceAddress = vm.addr(3);
    }

    function test_Attacker_Should_Not_Steal_Ownership() public {
        // Simulate the attack from the attacker's perspective
        vm.deal(attackerAddress, 1 ether);
        vm.startPrank(attackerAddress);
        attack.attack{value: 1 ether}();
        vm.stopPrank();

        // Simulate Alice claiming the throne
        vm.deal(aliceAddress, 2 ether);
        vm.startPrank(aliceAddress);
        gameOfEther.claimThrone{value: 2 ether}();
        vm.stopPrank();

        // Assert that Alice is the winner
        assertEq(gameOfEther.winner(), aliceAddress, "Alice should be the winner");

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Attacker_Should_Not_Steal_Ownership");
    }
}
