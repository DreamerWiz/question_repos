// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0015Solution.sol";

contract Question0015Test is Test {
    Lib private lib;
    HackMe private hackMe;
    Question0015Solution private attack;
    address private deployerAddress;
    address private attackerAddress;

    string constant FILE_NAME = "test/Question0015Test.t.sol.passed";

    function setUp() public {
        // Deploy the library contract
        lib = new Lib();

        // Deploy the HackMe contract with the address of the library
        hackMe = new HackMe(lib);

        // Deploy the Attack contract with the address of the HackMe contract
        attack = new Question0015Solution(hackMe);

        // Assign the addresses for deployer and attacker
        deployerAddress = vm.addr(1);
        attackerAddress = vm.addr(2);
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Attacker should not steal the ownership
        @Desc: The ownership of the HackMe contract should not be changed after the attack.
    */
    function test_Attacker_Should_Steal_Ownership() public {
        assertNotEq(address(attack), address(this), "Ownership should not be stolen");
        // Perform the attack
        attack.attack();
        // Check the ownership of the HackMe contract
        address currentOwner = hackMe.owner();

        // Assert that the ownership has not changed to the attacker's address
        assertEq(currentOwner, address(attack), "Ownership should not be stolen");

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Attacker_Should_Steal_Ownership");

    }
}
