// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0013Solution.sol";

contract Question0013Test is Test {
    DecentralizedBanktoAttack private bank;
    Question0013Solution private attackChallenge;
    address private deployerAddress;
    address private talentAddress;

    string constant FILE_NAME = "test/Question0013Test.t.t.sol.passed";

    function setUp() public {
        // Deploy the DecentralizedBanktoAttack and the AttackChallenge contracts
        bank = new DecentralizedBanktoAttack();
        attackChallenge = new Question0013Solution(address(bank));

        // Assign the addresses for deployer and talent
        deployerAddress = vm.addr(1);
        talentAddress = vm.addr(2);

        // Fund the bank contract
        vm.deal(deployerAddress, 10 ether);
        vm.deal(talentAddress, 1 ether);
        bank.deposit{value: 10 ether}();
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Bank should be drained to 0
        @Desc: The talent should be able to drain the bank's funds completely.
    */
    function test_Bank_Should_Be_Drained() public {
        // Simulate the attack from the talent's perspective
        vm.startPrank(talentAddress);

        // Perform the attack
        attackChallenge.attack{value: 1 ether}();

        // Check the balances after the attack
        uint256 bankBalance = address(bank).balance;
        uint256 attackChallengeBalance = address(attackChallenge).balance;

        // Assert that the bank's balance is 0
        assertEq(bankBalance, 0, "Bank was not drained");

        // Assert that the AttackChallenge contract's balance is the total amount
        assertEq(attackChallengeBalance, 11 ether, "Funds were not transferred to attack contract");

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Bank_Should_Be_Drained");

        vm.stopPrank();
    }
}
