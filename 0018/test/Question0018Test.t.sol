// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0018Solution.sol";
import "../contracts/Question0018Ext.sol";

contract Question0018Test is Test {
    Target private target;
    Question0018Solution private attack;
    address private deployerAddress;
    address private attackerAddress;
    address private aliceAddress;

    string constant FILE_NAME = "test/Question0018Test.t.sol.passed";

    function setUp() public {
        // Deploy the Target contract
        target = new Target();

        // Deploy the Question0018Solution contract with the address of the Target contract
        attack = new Question0018Solution(address(target));

        // Assign the addresses for deployer, attacker, and Alice
        deployerAddress = vm.addr(1);
        attackerAddress = vm.addr(2);
        aliceAddress = vm.addr(3);
    }

    function test_Attacker_Should_Not_Steal_Ownership() public {
        // Perform any necessary actions to test the 'pwned' state

        // Assert that the 'pwned' state of the Target contract is as expected
        assertTrue(target.pwned(), "Target should be pwned");

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Attacker_Should_Not_Steal_Ownership");
    }
}
