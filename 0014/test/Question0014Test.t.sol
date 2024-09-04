// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0014Solution.sol";

contract Question0014Test is Test {
    Question0014Solution private bankFixChallenge;
    Attack private attackContract;
    address private deployerAddress;
    address private talentAddress;

    string constant FILE_NAME = "test/Question0014Test.t.sol.passed";

    function setUp() public {
        // Deploy the fixed bank contract
        bankFixChallenge = new Question0014Solution();

        // Assign the addresses for deployer and talent
        deployerAddress = vm.addr(1);
        talentAddress = vm.addr(2);

        // Deploy the attack contract
        attackContract = new Attack(address(bankFixChallenge));

        // Fund the bank contract with 10 ETH from the deployer address
        bankFixChallenge.deposit{value: 10 ether}();
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Bank should retain funds after attack
        @Desc: The bank should have 10 ETH even after a reverted attack attempt.
    */
    function test_Bank_Should_Retain_Funds_After_Attack() public {
        // Simulate the attack from the talent's perspective
        vm.startPrank(talentAddress);

        // Perform the attack and expect it to revert
        vm.expectRevert();
        attackContract.attack{value: 1 ether}();

        // Check the balance of the bank contract
        uint256 bankBalance = address(bankFixChallenge).balance;

        // Assert that the bank's balance is still 10 ETH
        assertEq(bankBalance, 10 ether, "Bank balance should remain unchanged");

        // Check the balance of the attack contract
        uint256 attackContractBalance = address(attackContract).balance;

        // Assert that the attack contract's balance is 0 ETH
        assertEq(attackContractBalance, 0 ether, "Attack contract should not have received any funds");

        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Bank_Should_Retain_Funds_After_Attack");

        vm.stopPrank();
    }
}
