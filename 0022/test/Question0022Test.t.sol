// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0022Solution.sol";


contract Question0022Test is Test {
    Question0022Solution private wallet;
    Attack private attack;
    address private deployerAddress;
    address private attackerAddress;
    address private aliceAddress;

    string constant FILE_NAME = "test/Question0022Test.t.sol.passed";

    function setUp() public {
        // Setup addresses for deployer, attacker, and Alice
        deployerAddress = vm.addr(1);
        attackerAddress = vm.addr(2);
        aliceAddress = vm.addr(3);

        // Deploy the Question0022Solution contract with 2 ETH
        vm.deal(deployerAddress, 10 ether); // Ensuring deployer has enough ether
        vm.startPrank(deployerAddress);
        wallet = new Question0022Solution{value: 2 ether}();
        vm.stopPrank();

        // Deploy the Attack contract
        attack = new Attack(wallet);

        // Assert the balance of the wallet contract is 2 ETH
        assertEq(address(wallet).balance, 2 ether);
    }

    function test_Should_Not_Lose_Money_Through_Phishing_Contract() public {
        // Connect deployer to the attack contract
        vm.startPrank(deployerAddress);

        // Attempt the phishing attack
        vm.expectRevert();
        attack.attack();

        // Assert that the wallet's balance remains unchanged
        assertEq(address(wallet).balance, 2 ether);

        vm.stopPrank();

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Should_Not_Lose_Money_Through_Phishing_Contract");
    }
}
