// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/StdStorage.sol";


import {Question1002Solution} from "../contracts/Question1002Solution.sol";
import {Question1002Attacker2, Question1002Attacker1, Question1002Attacker3, Question1002Attacker4} from "../contracts/Question1002Ext.sol";

contract Question1002Test is Test {
    using stdStorage for StdStorage;

    // FILE_NAME Must be the file name. + passed
    string constant FILE_NAME = "test/Question1002Test.t.sol.passed";

    Question1002Solution solution;
    Question1002Attacker1 attacker1;
    Question1002Attacker2 attacker2;
    Question1002Attacker3 attacker3;
    Question1002Attacker4 attacker4;
    address owner = address(1);
    address user1 = address(2);
    address user2 = address(3);
    address user3 = address(4);

    function setUp() public {
        solution = new Question1002Solution(owner, 5);
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Constructor should set the right owner and token price.
        @Desc : The owner and token price of the contract should equal to the parameters set in the constructor.
     */
    function test_Constructor_should_set_the_right_owner_and_token_price() public {
        assertEq(solution.owner(), owner);
        assertEq(solution.capacity(), 5);
        vm.writeLine(FILE_NAME, "\ntest_Constructor_should_set_the_right_owner_and_token_price");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Owner can mint token and non-owner cannot mint.
        @Desc : Only the owner can mint tokens via function mint() and normal users cannot.
    */
    function test_Owner_can_mint_token_and_non_owner_cannot_mint() public{
        vm.prank(owner);
        solution.mint(user1, 1);
        assertEq(solution.ownerOf(1), user1);

        vm.prank(user1);
        vm.expectRevert();
        solution.mint(user1, 2);
        vm.writeLine(FILE_NAME, "\ntest_Owner_can_mint_token_and_non_owner_cannot_mint");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Token owner can transfer his/her owner token.
        @Desc : The owner of the token can transfer the token to arbitrary user.
    */
    function test_Token_owner_can_transfer_his_or_her_own_token() public{
        vm.prank(owner);
        solution.mint(user1, 1);
        assertEq(solution.ownerOf(1), user1);
        vm.prank(user1);
        solution.transferFrom(user1, owner, 1);
        assertEq(solution.ownerOf(1), owner);
        vm.writeLine(FILE_NAME, "\ntest_Token_owner_can_transfer_his_or_her_own_token");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Can't transfer someone else's token unless have his/her approval.
        @Desc : The user cannot transfer others' tokens unless haveing their approvals.
     */
     function test_cant_transfer_someone_elses_token_unless_have_his_or_her_approval() public {
        vm.prank(owner);
        solution.mint(user1, 1);
        vm.prank(owner);
        vm.expectRevert();
        solution.transferFrom(user1, owner, 1);
        assertEq(solution.ownerOf(1), user1);
        vm.prank(user1);
        solution.approve(owner, 1);
        
        vm.prank(owner);
        solution.transferFrom(user1, owner, 1);

        assertEq(solution.ownerOf(1), owner);
        vm.writeLine(FILE_NAME, "\ntest_cant_transfer_someone_elses_token_unless_have_his_or_her_approval");
     }

     /* 
        @Topic : Basic
        @Score : 5
        @Title : Can't transfer the token if the token does not belong to the target user.
        @Desc : If the user does not own the token, then transfer the token of tokenId from the user should fail. 
     */
     function test_cant_transfer_the_token_if_the_token_does_not_belong_to_the_target_owner() public{
        vm.prank(owner); solution.mint(user1, 1);
        vm.expectRevert(); vm.prank(owner); solution.transferFrom(owner, user2, 1);
        vm.writeLine(FILE_NAME, "\ntest_cant_transfer_the_token_if_the_token_does_not_belong_to_the_target_owner");
     }

     /*
        @Topic : Basic
        @Score : 5
        @Title : Transfer any amount of the tokens if approved for all.
        @Desc : If the user has set approveAll for a target user, then the target user has the right to transfer all his assets without getting approved again.
     */
     function test_Transfer_any_amount_of_the_tokens_if_approved_for_all() public{
        vm.startPrank(owner);
        solution.mint(owner, 1);
        solution.mint(owner, 2);
        solution.mint(owner, 3);

        assertEq(solution.isApprovedForAll(owner, user1), false);
        solution.setApprovalForAll(user1, true);
        assertEq(solution.isApprovedForAll(owner, user1), true);

        vm.startPrank(user1);
        solution.transferFrom(owner, user1, 1);
        solution.transferFrom(owner, user1, 2);
        solution.transferFrom(owner, user1, 3);
        vm.writeLine(FILE_NAME, "\ntest_Transfer_any_amount_of_the_tokens_if_approved_for_all");
     }


     /*
        @Topic : Basic
        @Score : 5
        @Title : Mint cannot exceed capacity.
        @Desc : The totalsupply cannot exceed the capacity set in constructor.
     */
     function test_Mint_cannot_exceed_capacity() public{
        vm.startPrank(owner);
        solution.mint(owner, 1);
        solution.mint(owner, 2);
        solution.mint(owner, 3);
        solution.mint(owner, 4);
        solution.mint(owner, 5);
        vm.expectRevert();
        solution.mint(owner, 6);
        vm.writeLine(FILE_NAME, "\ntest_Mint_cannot_exceed_capacity");
     }


     /*
        @Topic : Basic
        @Score : 5
        @Title : Minted token has randomized share in the range of 50 to 99.
        @Desc : The totalsupply cannot exceed the capacity set in constructor.
     */
     function test_Minted_token_has_randomized_share_in_the_range_of_50_to_99() public{
        solution = new Question1002Solution(owner, 100);
        for(uint i=0;i<100;i++){
            vm.prank(owner);
            solution.mint(owner, i+1);
            uint share = solution.tokenShare(i+1);
            assert(share >= 50 && share <= 99);
        }
        vm.writeLine(FILE_NAME, "\ntest_Minted_token_has_randomized_share_in_the_range_of_50_to_99");
     }

     
     /*
        @Topic : Basic
        @Score : 5
        @Title : Normal dividend.
        @Desc : Users should get passive incomes from the dividends as per the requirement.
     */
     function test_Normal_dividend() public{
        vm.startPrank(owner);

        solution.mint(user1, 1);
        solution.mint(user2, 2);
        solution.mint(user3, 3);

        uint share1 = solution.tokenShare(1);
        uint share2 = solution.tokenShare(2);
        uint share3 = solution.tokenShare(3);

        uint totalShare = share1+share2+share3;
        vm.stopPrank();
        
        hoax(owner, totalShare * 1e18);
        solution.allocate{value: totalShare * 1e18}();
        vm.prank(user1); assertEq(solution.earned(), share1 * 1e18);
        vm.prank(user2); assertEq(solution.earned(), share2 * 1e18);
        vm.prank(user3); assertEq(solution.earned(), share3 * 1e18);
        vm.writeLine(FILE_NAME, "\ntest_Normal_dividend");
     }

     /*
        @Topic : Basic
        @Score : 5
        @Title : Not owner cannot set capacity via function setCapacity().
        @Desc : Only owner can set capacity via function setCapacity(), non-owner cannot set.
     */
     function test_Not_owner_cannot_set_capacity_via_function_setCapacity() public{
        vm.prank(owner);
        solution.setCapacity(10);
        assertEq(solution.capacity(), 10);

        vm.prank(user1); vm.expectRevert();
        solution.setCapacity(11);
        vm.writeLine(FILE_NAME, "\ntest_Not_owner_cannot_set_capacity_via_function_setCapacity");
     }


     /*
        @Topic : Detail
        @Score : 5
        @Title : Should fail deployment when owner is zero or capacity is zero.
        @Desc : When deploying the contract, if the parameter is zero value, it should revert.
     */
     function test_Should_fail_deployment_when_owner_is_zero_or_capacity_is_zero() public{
        vm.expectRevert();
        new Question1002Solution(address(0), 5);
        vm.expectRevert();
        new Question1002Solution(owner, 0);
        vm.writeLine(FILE_NAME, "\ntest_Should_fail_deployment_when_owner_is_zero_or_capacity_is_zero");
     }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Should fail if set capacity to zero via setCapacity().
        @Desc : If the parameter is zero, the function setCapacity() should fail.
    */
    function test_Should_fail_if_set_capacity_to_zero_via_setCapacity() public {
        vm.expectRevert();
        solution.setCapacity(0);
        vm.writeLine(FILE_NAME, "\ntest_Should_fail_if_set_capacity_to_zero_via_setCapacity");
    }


    /*
        @Topic : Detail
        @Score : 5
        @Title : Should fail if set capacity lower than current supply via setCapacity().
        @Desc : If the parameter is lower than current supply, the call of setCapacity() should fail.
    */
    function test_Should_fail_if_set_capacity_lower_than_current_supply_via_setCapacity() public {
        vm.startPrank(owner);
        solution.mint(owner, 1);
        solution.mint(owner, 2);
        solution.mint(owner, 3);
        vm.expectRevert();
        solution.setCapacity(2);
        vm.writeLine(FILE_NAME, "\ntest_Should_fail_if_set_capacity_lower_than_current_supply_via_setCapacity");
    }


    /*
        @Topic : Detail
        @Score : 5
        @Title : Cannot mint to zero address.
        @Desc : Cannot mint tokens for a zero address.
    */
    function test_Cannot_mint_to_zero_address() public {
        vm.startPrank(owner);
        vm.expectRevert();
        solution.mint(address(0), 1);
        vm.writeLine(FILE_NAME, "\ntest_Cannot_mint_to_zero_address");
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Cannot allocate when total share is zero.
        @Desc : When the total share is zero, allocate() should fail.
    */
    function test_Cannot_allocate_when_total_share_is_zero() public {
        vm.expectRevert();
        hoax(owner, 1000 ether);
        solution.allocate{value: 1000 ether}();
        vm.writeLine(FILE_NAME, "\ntest_Cannot_allocate_when_total_share_is_zero");
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Allocate should attribute the whole rewards without leftover or return the left money.
        @Desc : There shouldn't be left money in function allocate().
    */
    function test_Allocate_should_attribute_the_whole_rewards_without_leftover_or_return_the_left_money() public {
        vm.startPrank(owner);

        solution.mint(user1, 1);
        solution.mint(user2, 2);
        solution.mint(user3, 3);

        uint share1 = solution.tokenShare(1);
        uint share2 = solution.tokenShare(2);
        uint share3 = solution.tokenShare(3);

        uint totalShare = share1 + share2 + share3;
        vm.stopPrank();

        hoax(owner, 1000 ether);
        solution.allocate{value: 1000 ether}();
        vm.prank(user1); uint earned1 = solution.earned();
        vm.prank(user2); uint earned2 = solution.earned();
        vm.prank(user3); uint earned3 = solution.earned();

        assertEq(earned1 + earned2 + earned3, address(solution).balance);
        vm.writeLine(FILE_NAME, "\ntest_Allocate_should_attribute_the_whole_rewards_without_leftover_or_return_the_left_money");
    }


    /*
        @Topic : Security
        @Score : 5
        @Title : Should use .call to transfer ETH rather than .transfer to support proxy contracts.
        @Desc : The function should not use transfer to do ETH transfers.
    */
    function test_Should_use_function_call_to_transfer_ETH_rather_than_transfer_to_support_proxy_contracts() public {
        vm.prank(owner);
        solution.mint(user1, 1);
        attacker2 = new Question1002Attacker2(address(solution));
        attacker2.attack{value: 1000 ether}();
        vm.writeLine(FILE_NAME, "\ntest_Should_use_function_call_to_transfer_ETH_rather_than_transfer_to_support_proxy_contracts");
    }


    /*
        @Topic : Security
        @Score : 5
        @Title : Should check the result of .call function to revert if failed.
        @Desc : The result of .call should be checked to ensure it's a successful transfer.
    */
    function test_Should_check_the_result_of_call_function_to_revert_if_failed() public {
        attacker1 = new Question1002Attacker1(address(solution));
        vm.prank(owner); solution.mint(user1, 1);
        vm.expectRevert();
        hoax(owner, 1000 ether);
        attacker1.attack{value: 1000 ether}();
        vm.writeLine(FILE_NAME, "\ntest_Should_check_the_result_of_call_function_to_revert_if_failed");
    }


    /*
        @Topic : Security
        @Score : 5
        @Title : Should prohibit reentrancy issue in allocate().
        @Desc : Should prohibit reentrancy issue in allocate().
    */
    function test_Should_prohibit_reentrancy_issue_in_allocate() public {
        attacker3 = new Question1002Attacker3(address(solution));
        vm.prank(owner); solution.mint(user1, 1);

        vm.expectRevert();
        attacker3.attack{value: 1000 ether}();
        vm.writeLine(FILE_NAME, "\ntest_Should_prohibit_reentrancy_issue_in_allocate");
    }


    /*
        @Topic : Security
        @Score : 5
        @Title : Should prohibit reentrancy issue in claim().
        @Desc : Should prohibit reentrancy issue in claim().
    */
    function test_Should_prohibit_reentrancy_issue_in_claim() public {
        attacker4 = new Question1002Attacker4(address(solution));
        vm.prank(owner); solution.mint(address(attacker4), 1);
        hoax(owner, 1000 ether); solution.allocate{value: 1000 ether}();
        vm.expectRevert();
        hoax(owner, 1000 ether);
        attacker4.attack{value: 1000 ether}();
        vm.writeLine(FILE_NAME, "\ntest_Should_prohibit_reentrancy_issue_in_claim");
    }

    /*
        @Topic : Security
        @Score : 5
        @Title : Should correctly process the rewards during transfers
        @Desc : The rewards should be calculated when the token is transferred.
    */
    function test_Should_correctly_process_the_rewards_during_transfers() public {
        vm.startPrank(owner);
        solution.mint(user1, 1);
        solution.mint(user2, 2);

        uint share1 = solution.tokenShare(1);
        uint share2 = solution.tokenShare(2);

        uint totalShare = share1 + share2;
        vm.stopPrank();
        hoax(owner, totalShare * 1e18);
        solution.allocate{value: totalShare * 1e18}();
        vm.prank(user1); solution.transferFrom(user1, user2, 1);
        hoax(owner, totalShare * 1e18);
        solution.allocate{value: totalShare * 1e18}();
        uint earned1 = share1;
        uint earned2 = share2 + totalShare;
        vm.prank(user1); assertEq(solution.earned(), earned1 * 1e18);
        vm.prank(user2); assertEq(solution.earned(), earned2 * 1e18);
        vm.writeLine(FILE_NAME, "\ntest_Should_correctly_process_the_rewards_during_transfers");
    }
}