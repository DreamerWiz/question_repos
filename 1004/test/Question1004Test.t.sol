// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Question1004Solution} from "../contracts/Question1004Solution.sol";
import {Question1004Attacker1, Question1004Attacker2, Question1004Attacker3, Question1004Attacker4} from "../contracts/Question1004Ext.sol";

contract Question1004Test is Test {
    string constant FILE_NAME = "test/Question1004Test.t.sol.passed";

    Question1004Solution insuranceContract;
    Question1004Attacker1 attacker1;
    Question1004Attacker2 attacker2;
    Question1004Attacker3 attacker3;
    Question1004Attacker4 attacker4;
    address owner = address(1);
    address user1 = address(2);
    address user2 = address(3);
    address addr1 = address(4);

    function setUp() public {
        vm.deal(owner, 100 ether);
        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.prank(owner);
        insuranceContract = new Question1004Solution();
        attacker1 = new Question1004Attacker1(address(insuranceContract));
        attacker2 = new Question1004Attacker2(address(insuranceContract));
        attacker3 = new Question1004Attacker3(address(insuranceContract));
        attacker4 = new Question1004Attacker4(address(insuranceContract));
    }

    function calculatePremium(
        uint _currentFunds,
        uint _currentCoverage,
        uint _coverageAmount
    ) internal pure returns (uint) {
        uint o_safeTier = (_coverageAmount * 995) / 1000;
        uint newCoverage = (_currentCoverage + _coverageAmount);
        uint safeTier = (newCoverage * 995) / 1000;
        uint capitalRatio = (_coverageAmount * (_currentFunds - o_safeTier)) /
            (_currentFunds - safeTier);
        return (_coverageAmount * 1 + capitalRatio) / 100;
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should mint a new monster.
        @Desc  : User should mint a new monster and update the id of owner.
    */
    function test_Should_getPoolCreatedTimestamp_successfully() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        assertGt(insuranceContract.getPoolCreatedTimestamp(addr1), 0);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_getPoolCreatedTimestamp_successfully"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should getDepositTimestamp successfully
        @Desc  : Test to check if the getDepositTimestamp function returns the correct timestamp.
    */
    function test_Should_getDepositTimestamp_successfully() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 1 ether}(addr1);
        assertGt(insuranceContract.getDepositTimestamp(addr1, user1), 0);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_getDepositTimestamp_successfully"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should owner call addOneYearInsurancePool successfully
        @Desc  : Test to ensure that the owner can successfully call the addOneYearInsurancePool function.
    */
    function test_Should_owner_call_addOneYearInsurancePool_successfully()
        public
    {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_owner_call_addOneYearInsurancePool_successfully"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should User depositFunds successfully
        @Desc  : Test to ensure that the user can deposit funds successfully.
    */
    function test_Should_User_depositFunds_successfully() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 1 ether}(addr1);
        assertEq(
            insuranceContract.getFundOfInsurerInPool(addr1, user1),
            1 ether
        );
        vm.writeLine(FILE_NAME, "\ntest_Should_User_depositFunds_successfully");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should user call insure successfully
        @Desc  : Test to ensure that the user can successfully call the insure function.
    */
    function test_Should_user_call_insure_successfully() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        uint256 premium = insuranceContract.calculatePremium(9 ether, addr1);
        vm.prank(user2);
        insuranceContract.insure{value: premium}(9 ether, addr1);
        assertEq(
            insuranceContract.getPolicyCoverageAmountInPool(addr1, user2),
            9 ether
        );
        vm.writeLine(FILE_NAME, "\ntest_Should_user_call_insure_successfully");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should owner approve policy successfully
        @Desc  : Test to ensure that the owner can successfully approve an insurance policy.
    */
    function test_Should_owner_approve_policy_successfully() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        uint256 premium = insuranceContract.calculatePremium(9 ether, addr1);
        vm.prank(user2);
        insuranceContract.insure{value: premium}(9 ether, addr1);
        vm.prank(owner);
        insuranceContract.approveClaimCoverage(addr1, user2);
        assertTrue(insuranceContract.isPolicyIsApproved(addr1, user2));
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_owner_approve_policy_successfully"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should user claim coverage successfully
        @Desc  : Test to ensure that the user can successfully claim coverage.
    */
    function test_Should_user_claim_coverage_successfully() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        uint256 premium = insuranceContract.calculatePremium(4 ether, addr1);
        vm.prank(user2);
        insuranceContract.insure{value: premium}(4 ether, addr1);
        vm.prank(owner);
        insuranceContract.approveClaimCoverage(addr1, user2);
        // Capture balance before transaction
        uint256 balanceBefore = user2.balance;
        vm.prank(user2);
        insuranceContract.claimCoverage(addr1);
        uint256 balanceAfter = user2.balance;
        // Assert that balance has increased by 4 ether (or your coverage amount)
        assertEq(balanceBefore + 4 ether, balanceAfter);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_user_claim_coverage_successfully"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : After 365 days user should claim premium successfully
        @Desc  : Test to ensure that the user can successfully claim premium after 365 days.
    */
    function test_After_365_days_user_should_claim_premium_successfully()
        public
    {
        uint currentPremium = 0;
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        uint256 premium1 = insuranceContract.calculatePremium(1 ether, addr1);
        currentPremium += premium1;
        vm.prank(user1);
        insuranceContract.insure{value: premium1}(1 ether, addr1);
        uint256 premium2 = insuranceContract.calculatePremium(4 ether, addr1);
        currentPremium += premium2;
        vm.prank(user2);
        insuranceContract.insure{value: premium2}(4 ether, addr1);
        vm.prank(owner);
        insuranceContract.approveClaimCoverage(addr1, user2);

        vm.prank(user2);
        insuranceContract.claimCoverage(addr1);
        vm.warp(block.timestamp + 366 days);

        uint256 balanceBefore = user1.balance;
        vm.prank(user1);
        insuranceContract.claimPremium(addr1);
        uint creationTimestamp = insuranceContract.getPoolCreatedTimestamp(
            addr1
        );
        uint depositTimestamp = insuranceContract.getDepositTimestamp(
            addr1,
            user1
        );
        uint timeElapsed = creationTimestamp + 365 days - depositTimestamp;
        uint premiumShareFee = currentPremium / 2;
        uint share = (premiumShareFee * timeElapsed) / 365 days;
        uint claimAmount = share + 6 ether;

        uint256 balanceAfter = user1.balance;
        assertEq(balanceAfter, balanceBefore + claimAmount);
        vm.writeLine(
            FILE_NAME,
            "\ntest_After_365_days_user_should_claim_premium_successfully"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should calculatePremium() return correctly
        @Desc  : Test to ensure that the calculatePremium() function returns the expected amount.
    */
    function test_Should_calculatePremium_return_correctly() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        uint256 premium = insuranceContract.calculatePremium(
            1 ether,
            address(addr1)
        );
        uint256 expected = calculatePremium(10 ether, 0, 1 ether); // Your utility function
        assertEq(premium, expected);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_calculatePremium_return_correctly"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Check addOneYearInsurancePool() should only called by owner
        @Desc  : Test to ensure that the addOneYearInsurancePool() should only called by owner.
    */
    function test_Check_addOneYearInsurancePool_should_only_called_by_owner()
        public
    {
        vm.prank(user1);
        vm.expectRevert();
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_addOneYearInsurancePool()_should_only_called_by_owner"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Check approveClaimCoverage() should only called by owner
        @Desc  : Test to ensure that the approveClaimCoverage() should only be called by the owner.
    */
    function test_Check_approveClaimCoverage_should_only_called_by_owner()
        public
    {
        vm.prank(user1);
        vm.expectRevert();
        insuranceContract.approveClaimCoverage(addr1, user1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_approveClaimCoverage_should_only_called_by_owner"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Check depositFunds() should revert if repeatly deposit
        @Desc  : Test to ensure that the depositFunds() should revert if repeatedly depositing.
    */
    function test_Check_depositFunds_should_revert_if_repeatly_deposit()
        public
    {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        vm.prank(user1);
        vm.expectRevert();
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_depositFunds_should_revert_if_repeatly_deposit"
        );
    }
    /*
        @Topic : Detail
        @Score : 5
        @Title : Check claimPremium() should revert if pool was not end
        @Desc  : Test to ensure that the claimPremium() should revert if the pool was not ended.
    */
    function test_Check_claimPremium_should_revert_if_pool_not_end() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        vm.prank(user1);
        vm.expectRevert();
        insuranceContract.claimPremium(addr1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_claimPremium_should_revert_if_pool_not_end"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Check claimPremium() should revert if never deposit
        @Desc  : Test to ensure that the claimPremium() should revert if never deposit.
    */
    function test_Check_claimPremium_should_revert_if_never_deposit() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.warp(block.timestamp + 366 days);
        vm.expectRevert();
        vm.prank(user1);
        insuranceContract.claimPremium(addr1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_claimPremium_should_revert_if_never_deposit"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Check approveClaimCoverage() should revert if no coverage to approve
        @Desc  : Test to ensure that the approveClaimCoverage() should revert if no coverage to approve.
    */
    function test_Check_approveClaimCoverage_should_revert_if_no_coverage_to_approve()
        public
    {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        vm.expectRevert();
        insuranceContract.approveClaimCoverage(addr1, user1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_approveClaimCoverage_should_revert_if_no_coverage_to_approve"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Check claimCoverage() should revert if coverage is not approved
        @Desc  : Test to ensure that claimCoverage() function reverts if the coverage is not approved by the contract owner.
    */
    function test_Check_claimCoverage_should_revert_if_coverage_is_not_approved()
        public
    {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        uint256 premium = insuranceContract.calculatePremium(4 ether, addr1);
        vm.prank(user2);
        insuranceContract.insure{value: premium}(4 ether, addr1);
        vm.expectRevert();
        vm.prank(user2);
        insuranceContract.claimCoverage(addr1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_claimCoverage_should_revert_if_coverage_is_not_approved"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Check insure() should revert if coverage exceed the current funds
        @Desc  : Test to ensure that insure() function reverts if the coverage exceeds the current funds in the pool.
    */
    function test_Check_insure_should_revert_if_coverage_exceed_current_funds()
        public
    {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        uint256 premium = insuranceContract.calculatePremium(4 ether, addr1);
        vm.prank(user2);
        insuranceContract.insure{value: premium}(4 ether, addr1);
        uint256 premium2 = insuranceContract.calculatePremium(7 ether, addr1);
        vm.expectRevert();
        vm.prank(user2);
        insuranceContract.insure{value: premium2}(7 ether, addr1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_insure_should_revert_if_coverage_exceed_current_funds"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Check msg value should equal to the premium in insure
        @Desc  : Test to ensure that insure() function reverts if the sent ether is not equal to the calculated premium.
    */
    function test_Check_msg_value_should_equal_to_premium_in_insure() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(addr1);
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(addr1);
        uint256 premium = insuranceContract.calculatePremium(4 ether, addr1);
        vm.expectRevert();
        vm.prank(user2);
        insuranceContract.insure{value: premium - 1}(4 ether, addr1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_msg_value_should_equal_to_premium_in_insure"
        );
    }

    /*
        @Topic : Security
        @Score : 5
        @Title : Should use .call to transfer ETH in claimCoverage() rather than .transfer to support proxy contracts
        @Desc  : Test to ensure that claimCoverage() function should use .call to transfer funds instead of .transfer() for compatibility with proxy contracts.
    */
    function test_Use_call_to_transfer_in_claimCoverage() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(address(attacker1));
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(address(attacker1));
        attacker1.initForTwo{value: 10 ether}();
        vm.prank(owner);
        insuranceContract.approveClaimCoverage(
            address(attacker1),
            address(attacker1)
        );
        vm.prank(user1);
        attacker1.attack2{value: 10 ether}();

        vm.writeLine(FILE_NAME, "\ntest_Use_call_to_transfer_in_claimCoverage");
    }

    /*
        @Topic : Security
        @Score : 5
        @Title : Should use .call to transfer ETH in claimPremium() rather than .transfer to support proxy contracts
        @Desc  : Test to ensure that claimPremium() function should use .call to transfer funds instead of .transfer() for compatibility with proxy contracts.
    */
    function test_Use_call_to_transfer_in_claimPremium() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(address(attacker1));
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(address(attacker1));
        attacker1.initForThree{value: 10 ether}();
        vm.warp(block.timestamp + 366 days);
        vm.prank(user1);
        attacker1.attack3{value: 10 ether}();
        vm.writeLine(FILE_NAME, "\ntest_Use_call_to_transfer_in_claimPremium");
    }

    /*
        @Topic : Security
        @Score : 5
        @Title : Should check the result of .call function to revert if failed in claimCoverage()
        @Desc  : Test to ensure that claimCoverage() checks the return value of .call and reverts if the call was unsuccessful.
    */
    function test_Check_result_of_call_to_revert_in_claimCoverage() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(address(attacker2));
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(address(attacker2));
        attacker2.initForTwo{value: 10 ether}();
        vm.prank(owner);
        insuranceContract.approveClaimCoverage(
            address(attacker2),
            address(attacker2)
        );
        vm.prank(user1);
        vm.expectRevert();
        attacker2.attack2{value: 10 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_result_of_call_to_revert_in_claimCoverage"
        );
    }

    /*
        @Topic : Security
        @Score : 5
        @Title : Should check the result of .call function to revert if failed in claimPremium()
        @Desc  : Test to ensure that claimPremium() checks the return value of .call and reverts if the call was unsuccessful.
    */
    function test_Check_result_of_call_to_revert_in_claimPremium() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(address(attacker2));
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(address(attacker2));
        attacker2.initForThree{value: 10 ether}();
        vm.warp(block.timestamp + 366 days);
        vm.prank(user1);
        vm.expectRevert();
        attacker2.attack3{value: 10 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Check_result_of_call_to_revert_in_claimPremium"
        );
    }

    /*
        @Topic : Security
        @Score : 5
        @Title : Should prohibit reentrancy issue in claimCoverage()
        @Desc  : Test to ensure that claimCoverage() function prevents reentrancy attacks.
    */
    function test_Prohibit_reentrancy_in_claimCoverage() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(address(attacker3));
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(address(attacker3));
        attacker3.initForTwo{value: 10 ether}();
        vm.prank(owner);
        insuranceContract.approveClaimCoverage(
            address(attacker3),
            address(attacker3)
        );
        vm.prank(user1);
        vm.expectRevert();
        attacker3.attack{value: 10 ether}();
        vm.writeLine(FILE_NAME, "\ntest_Prohibit_reentrancy_in_claimCoverage");
    }

    /*
        @Topic : Security
        @Score : 5
        @Title : Should prohibit reentrancy issue in claimPremium()
        @Desc  : Test to ensure that claimPremium() function prevents reentrancy attacks.
    */
    function test_Prohibit_reentrancy_in_claimPremium() public {
        vm.prank(owner);
        insuranceContract.addOneYearInsurancePool(address(attacker4));
        vm.prank(user1);
        insuranceContract.depositFunds{value: 10 ether}(address(attacker4));
        attacker4.initForThree{value: 10 ether}();
        vm.warp(block.timestamp + 366 days);
        vm.prank(user1);
        vm.expectRevert();
        attacker4.attack{value: 10 ether}();
        vm.writeLine(FILE_NAME, "\ntest_Prohibit_reentrancy_in_claimPremium");
    }
}
