// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0023Solution.sol";

contract Question0023Test is Test {
    Logic private logic;
    Proxy private proxy;
    Question0023Solution private attack;
    address private deployerAddress;
    address private attackerAddress;
    address private aliceAddress;

    string constant FILE_NAME = "test/Question0023Test.t.sol.passed";

    function setUp() public {
        // Setup addresses for deployer, attacker, and Alice
        deployerAddress = vm.addr(1);
        attackerAddress = vm.addr(2);
        aliceAddress = vm.addr(3);

        // Deploy the Logic and Proxy contracts
        logic = new Logic();
        proxy = new Proxy(address(logic));

        // Deploy the ProxyAttack contract
        attack = new Question0023Solution(address(logic));

        // Prepare accounts
        vm.deal(deployerAddress, 10 ether); // Ensuring deployer has enough ether
        vm.deal(attackerAddress, 10 ether); // Ensuring attacker has enough ether
        vm.startPrank(attackerAddress);

        assertTrue(address(logic).code.length > 0);
        // Perform the attack
        attack.attack();
        vm.stopPrank();

    }

    function test_Should_Destroy_Implementation_Contract() public {
        // Assert Logic contract bytecode is destroyed
        assertEq(address(logic).code, bytes(""));

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Should_Destroy_Implementation_Contract");
    }
}
