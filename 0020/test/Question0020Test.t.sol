// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0020Solution.sol";
import "../contracts/Question0020Ext.sol";

contract Question0020Test is Test {
    NewCoin private newCoin;
    Question0020Solution private attack;
    address private deployerAddress;
    address private attackerAddress;
    address private aliceAddress;

    string constant FILE_NAME = "test/Question0020Test.t.sol.passed";

    function setUp() public {
        // Setup addresses for deployer, attacker, and Alice
        deployerAddress = vm.addr(1);
        attackerAddress = vm.addr(2);
        aliceAddress = vm.addr(3);

        // Deploy the NewCoin contract
        newCoin = new NewCoin(attackerAddress);

        // Deploy the Attack contract
        attack = new Question0020Solution();
    }

    function test_Attacker_Should_Steal_Locked_Token() public {
        // Connect attacker to the attack contract
        vm.startPrank(attackerAddress);

        // Get the old balance of the attacker
        uint256 oldBalance = newCoin.balanceOf(attackerAddress);

        // Increase allowance for the attack contract
        newCoin.increaseAllowance(address(attack), oldBalance);

        // Execute the attack
        attack.attack(address(newCoin), attackerAddress);

        // Assert that the attacker's balance is now 0
        assertEq(newCoin.balanceOf(attackerAddress), 0);

        // Assert that the attack contract now holds the old balance
        assertEq(newCoin.balanceOf(address(attack)), oldBalance);

        vm.stopPrank();

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Attacker_Should_Steal_Locked_Token");
    }
}
