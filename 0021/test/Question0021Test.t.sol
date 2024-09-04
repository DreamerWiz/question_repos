// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0021Solution.sol";
import "../contracts/Question0021Ext.sol";

contract Question0021Test is Test {
    Question0021Solution private newCoin;
    Attack private attack;
    address private deployerAddress;
    address private attackerAddress;
    address private aliceAddress;

    string constant FILE_NAME = "test/Question0021Test.t.sol.passed";

    function setUp() public {
        // Setup addresses for deployer, attacker, and Alice
        deployerAddress = vm.addr(1);
        attackerAddress = vm.addr(2);
        aliceAddress = vm.addr(3);

        // Deploy the Question0021Solution contract
        newCoin = new Question0021Solution(attackerAddress);

        // Deploy the Attack contract
        attack = new Attack();
    }

    function test_Token_Should_Still_Be_Locked() public {
        // Connect attacker to the attack contract
        vm.startPrank(attackerAddress);

        // Get the old balance of the attacker
        uint256 oldBalance = newCoin.balanceOf(attackerAddress);

        // Attempt to increase allowance for the attack contract
        vm.expectRevert();
        newCoin.increaseAllowance(address(attack), oldBalance);

        // Attempt to execute the attack
        vm.expectRevert();
        attack.attack(address(newCoin), attackerAddress);

        // Assert that the attacker's balance remains unchanged
        assertEq(newCoin.balanceOf(attackerAddress), oldBalance);

        // Assert that the attack contract holds no tokens
        assertEq(newCoin.balanceOf(address(attack)), 0);

        vm.stopPrank();

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Token_Should_Still_Be_Locked");
    }
}
