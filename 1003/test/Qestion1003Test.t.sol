// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Question1003Solution} from "../contracts/Question1003Solution.sol";
import {Question1003Attacker1, Question1003Attacker2, Question1003Attacker3, Question1003Attacker4, Question1003Attacker5, Question1003Attacker6} from "../contracts/Question1003Ext.sol";

contract Question1003SolutionTest is Test {

    string constant FILE_NAME = "test/Question1003Test.t.sol.passed";

    Question1003Solution ethMonster;
    Question1003Attacker1 attacker1;
    Question1003Attacker2 attacker2;
    Question1003Attacker3 attacker3;
    Question1003Attacker4 attacker4;
    Question1003Attacker5 attacker5;
    Question1003Attacker6 attacker6;
    address owner = address(1);
    address user1 = address(2);
    address user2 = address(3);

    function setUp() public {
        vm.deal(owner, 100 ether);
        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.prank(owner);
        ethMonster = new Question1003Solution();
        attacker1 = new Question1003Attacker1(address(ethMonster));
        attacker2 = new Question1003Attacker2(address(ethMonster));
        attacker3 = new Question1003Attacker3(address(ethMonster));
        attacker4 = new Question1003Attacker4(address(ethMonster));
        attacker5 = new Question1003Attacker5(address(ethMonster));
        attacker6 = new Question1003Attacker6(address(ethMonster));
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should mint a new monster.
        @Desc  : User should mint a new monster and update the id of owner.
    */
    function test_Should_mint_a_new_monster() public {
        vm.prank(user1);
        ethMonster.mintMonster{value: 1 ether}();
        assertEq(ethMonster.ownerOf(1), user1);
        vm.writeLine(FILE_NAME, "\ntest_Should_mint_a_new_monster");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should send monster on a raid.
        @Desc  : User should be able to send their monster on a raid.
    */
    function test_Should_send_monster_on_a_raid() public {
        vm.prank(user1);
        ethMonster.mintMonster{value: 1 ether}();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        assertTrue(ethMonster.isOnRaid(1) == true);
        vm.writeLine(FILE_NAME, "\ntest_Should_send_monster_on_a_raid");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should not send monster on a raid if not owner.
        @Desc  : Test should revert if someone other than the owner tries to send the monster on a raid.
    */
    function test_Should_not_send_monster_on_a_raid_if_not_owner() public {
        vm.prank(user1);
        ethMonster.mintMonster{value: 1 ether}();
        vm.prank(user2); // Switch to another user

        vm.expectRevert();
        vm.prank(user2); // Switch to another user
        ethMonster.sendOnRaid(1, 10);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_not_send_monster_on_a_raid_if_not_owner"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should claim raid.
        @Desc  : User should be able to claim the raid and gain experience.
    */
    function test_Should_claim_raid() public {
        vm.prank(user1);
        ethMonster.mintMonster{value: 1 ether}();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.roll(block.number + 11); // Mine 10 new blocks to simulate time passing
        vm.prank(user1);
        ethMonster.claimRaid(1);
        assertNotEq(ethMonster.getExp(1), 0);
        vm.writeLine(FILE_NAME, "\ntest_Should_claim_raid");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should level up the monster.
        @Desc  : The monster should level up after gaining enough experience.
    */
    function test_Should_level_up_the_monster() public {
        vm.prank(user1);
        ethMonster.mintMonster{value: 1 ether}();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 20);
        vm.roll(block.number + 21); // Mine 20 new blocks to simulate time passing
        vm.prank(user1);
        ethMonster.claimRaid(1);
        vm.prank(user1);
        ethMonster.levelUp{value: 0.2 ether}(1);
        assertEq(ethMonster.getLevel(1), 2);
        vm.writeLine(FILE_NAME, "\ntest_Should_level_up_the_monster");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should not level up if not enough experience.
        @Desc  : Should revert if the monster doesn't have enough experience to level up.
    */
    function test_Should_not_level_up_if_not_enough_experience() public {
        vm.prank(user1);
        ethMonster.mintMonster{value: 1 ether}();

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.levelUp{value: 0.1 ether}(1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_not_level_up_if_not_enough_experience"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should not level up if not enough ether.
        @Desc  : Should revert if there is not enough ether to pay for the level up.
    */
    function test_Should_not_level_up_if_not_enough_ether() public {
        vm.prank(user1);
        ethMonster.mintMonster{value: 1 ether}();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 20);
        vm.roll(block.number + 21); // Mine 20 new blocks to simulate time passing
        vm.prank(user1);
        ethMonster.claimRaid(1);

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.levelUp{value: 0.05 ether}(1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_not_level_up_if_not_enough_ether"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should recall monster and reset raid status if raid is not yet finished.
        @Desc  : The monster should be recalled and its raid status should be reset if the raid is not yet finished.
    */
    function test_Should_recall_monster_and_reset_raid_status() public {
        vm.prank(user1);
        ethMonster.mintMonster{value: 1 ether}();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.prank(user1);
        ethMonster.recallMonster(1);
        assertEq(ethMonster.isOnRaid(1), false);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_recall_monster_and_reset_raid_status"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should recall monster and keep raid status if raid is finished.
        @Desc  : The monster should be recalled and keep its raid status if the raid is finished.
    */
    function test_Should_recall_monster_and_keep_raid_status() public {
        vm.prank(user1);
        ethMonster.mintMonster{value: 1 ether}();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.roll(block.number + 11); // Mine 10 new blocks to simulate time passing
        vm.prank(user1);
        ethMonster.recallMonster(1);
        assertEq(ethMonster.isOnRaid(1), false);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_recall_monster_and_keep_raid_status"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should abandon the monster.
        @Desc  : User should be able to abandon the monster, making it ownerless.
    */
    function test_Should_abandon_the_monster() public {
        vm.prank(user1);
        ethMonster.mintMonster{value: 1 ether}();
        vm.prank(user1);
        ethMonster.abandonMonster(1);
        assertEq(ethMonster.isAbandoned(1), true);
        vm.writeLine(FILE_NAME, "\ntest_Should_abandon_the_monster");
    }

    function beforeEachDetail() public {
        vm.prank(user1); // Setting the sender as addr1
        ethMonster.mintMonster{value: 1 ether}();
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should revert if msg.value is less than 1 ether when minting monster.
        @Desc  : Expect the mintMonster function to revert when the value is less than 1 ether.
    */
    function test_Should_revert_if_msg_value_is_less_than_1_ether() public {
        vm.expectRevert();
        vm.prank(user1);
        ethMonster.mintMonster{value: 0.5 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_if_msg_value_is_less_than_1_ether"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should fail if not owner or approved on sendOnRaid.
        @Desc  : Expect sendOnRaid to revert if not called by owner or approved account.
    */
    function test_Should_fail_if_not_owner_or_approved_on_sendOnRaid() public {
        beforeEachDetail();
        vm.prank(user2);

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_fail_if_not_owner_or_approved_on_sendOnRaid"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should fail if not owner or approved on abandonMonster.
        @Desc  : Expect abandonMonster to revert if not called by owner or approved account.
    */
    function test_Should_fail_if_not_owner_or_approved_on_abandonMonster()
        public
    {
        beforeEachDetail();
        vm.prank(user2);

        vm.expectRevert();
        vm.prank(user2);
        ethMonster.abandonMonster(1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_fail_if_not_owner_or_approved_on_abandonMonster"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should fail if not owner or approved on claimRaid.
        @Desc  : Expect claimRaid to revert if not called by owner or approved account.
    */
    function test_Should_fail_if_not_owner_or_approved_on_claimRaid() public {
        // ... The logic for simulating block advancement would go here, if applicable
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.roll(block.number + 11);
        vm.prank(user2);

        vm.expectRevert();
        vm.prank(user2);
        ethMonster.claimRaid(1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_fail_if_not_owner_or_approved_on_claimRaid"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should not allow sendOnRaid if monster is already on a raid.
        @Desc  : Expect sendOnRaid to revert if the monster is already on a raid.
    */
    function test_Should_not_allow_sendOnRaid_if_monster_is_already_on_raid()
        public
    {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.prank(user1);

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_not_allow_sendOnRaid_if_monster_is_already_on_raid"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should not allow abandonMonster if monster is already on a raid.
        @Desc  : Expect abandonMonster to revert if the monster is already on a raid.
    */
    function test_Should_not_allow_abandonMonster_if_monster_is_already_on_raid()
        public
    {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.prank(user1);

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.abandonMonster(1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_not_allow_abandonMonster_if_monster_is_already_on_raid"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should wait for raid to finish before claiming.
        @Desc  : Expect claimRaid to revert if the raid is not yet finished.
    */
    function test_Should_wait_for_raid_to_finish_before_claiming() public {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.claimRaid(1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_wait_for_raid_to_finish_before_claiming"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should not allow levelUp if monster is already on a raid.
        @Desc  : Expect levelUp to revert if the monster is already on a raid.
    */
    function test_Should_not_allow_levelUp_if_monster_is_already_on_raid()
        public
    {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.roll(block.number + 11);
        vm.prank(user1);
        ethMonster.claimRaid(1);
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.levelUp(1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_not_allow_levelUp_if_monster_is_already_on_raid"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should revert sendOnRaid if monster is abandoned.
        @Desc  : Expect sendOnRaid to revert if the monster is abandoned.
    */
    function test_Should_revert_sendOnRaid_if_monster_is_abandoned() public {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.abandonMonster(1);
        vm.prank(user1);

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_sendOnRaid_if_monster_is_abandoned"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should revert claimRaid if monster is abandoned.
        @Desc  : Expect claimRaid to revert if the monster is abandoned.
    */
    function test_Should_revert_claimRaid_if_monster_is_abandoned() public {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.prank(user1);
        ethMonster.recallMonster(1);
        vm.prank(user1);
        ethMonster.abandonMonster(1);
        vm.prank(user1);

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.claimRaid(1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_claimRaid_if_monster_is_abandoned"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should revert levelUp if monster is abandoned.
        @Desc  : Expect levelUp to revert if the monster is abandoned.
    */
    function test_Should_revert_levelUp_if_monster_is_abandoned() public {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.roll(block.number + 11);
        vm.prank(user1);
        ethMonster.claimRaid(1);
        vm.prank(user1);
        ethMonster.abandonMonster(1);
        vm.prank(user1);

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.levelUp{value: 0.2 ether}(1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_levelUp_if_monster_is_abandoned"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should revert abandonMonster if monster is already abandoned.
        @Desc  : Expect abandonMonster to revert if the monster is already abandoned.
    */
    function test_Should_revert_abandonMonster_if_monster_is_already_abandoned()
        public
    {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.abandonMonster(1);
        vm.prank(user1);

        vm.expectRevert();
        vm.prank(user1);
        ethMonster.abandonMonster(1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_abandonMonster_if_monster_is_already_abandoned"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should revert transfer if monster is abandoned.
        @Desc  : Expect transferFrom to revert if the monster is abandoned.
    */
    function test_Should_revert_transfer_if_monster_is_abandoned() public {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.abandonMonster(1);
        vm.prank(user1);
        vm.expectRevert();
        ethMonster.transferFrom(user1, owner, 1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_transfer_if_monster_is_abandoned"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should check balance difference equals claim reward.
        @Desc  : Expect balance to fit the claimed reward.
    */
    function test_Should_check_balance_difference_equals_claim_reward() public {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.roll(block.number + 11);
        uint balance_before = user1.balance;
        vm.prank(user1);
        ethMonster.claimRaid(1);
        uint balance_after = user1.balance;
        assertEq(balance_before + 0.001 ether, balance_after);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_check_balance_difference_equals_claim_reward"
        );
    }

    /*
        @Topic : Detail
        @Score : 10
        @Title : Should cancel raid status and have no rewards on recall.
        @Desc  : Expect balance to fit the claimed reward with recall.
    */
    function test_Should_cancel_raid_status_and_have_no_rewards_on_recall()
        public
    {
        beforeEachDetail();
        vm.prank(user1);
        ethMonster.sendOnRaid(1, 10);
        vm.prank(user1);
        ethMonster.recallMonster(1);
        vm.roll(block.number + 11);
        uint balance_before = user1.balance;
        vm.prank(user1);
        ethMonster.claimRaid(1);
        uint balance_after = user1.balance;
        assertEq(balance_before, balance_after);

        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_cancel_raid_status_and_have_no_rewards_on_recall"
        );
    }

    /*
        @Topic : SECURITY
        @Score : 10
        @Title : Should use .call to transfer ETH in claimRaid rather than .transfer to support proxy contracts.
        @Desc  : Test to ensure that claimRaid uses .call to support proxy contracts.
    */
    function test_Should_use_call_to_transfer_ETH_in_claimRaid() public {
        vm.prank(user1);
        attacker1.init{value: 1 ether}();
        vm.roll(block.number + 11);      
        vm.prank(user1);
        attacker1.attack();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_use_call_to_transfer_ETH_in_claimRaid"
        );
    }

    /*
        @Topic : SECURITY
        @Score : 10
        @Title : Should use .call to transfer ETH in abandonMonster rather than .transfer to support proxy contracts.
        @Desc  : Test to ensure that abandonMonster uses .call to support proxy contracts.
    */
    function test_Should_use_call_to_transfer_ETH_in_abandonMonster() public {
        vm.prank(user1);
        attacker2.init{value: 1 ether}();     
        vm.prank(user1);
        attacker2.attack();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_use_call_to_transfer_ETH_in_abandonMonster"
        );
    }

    /*
        @Topic : SECURITY
        @Score : 10
        @Title : Should check the result of .call function to revert if failed in claimRaid.
        @Desc  : Test to ensure that claimRaid checks the result of the .call function and reverts if the call failed.
    */
    function test_Should_check_result_of_call_to_revert_if_failed_in_claimRaid() public {
        vm.prank(user1);
        attacker3.init{value: 1 ether}();
        vm.roll(block.number + 11);      
        vm.prank(user1);
        vm.expectRevert();    
        attacker3.attack();
        vm.writeLine(FILE_NAME, "\ntest_Should_check_result_of_call_to_revert_if_failed_in_claimRaid");
    }

    /*
        @Topic : SECURITY
        @Score : 10
        @Title : Should check the result of .call function to revert if failed in abandonMonster.
        @Desc  : Test to ensure that abandonMonster checks the result of the .call function and reverts if the call failed.
    */
    function test_Should_check_result_of_call_to_revert_if_failed_in_abandonMonster() public {
        vm.prank(user1);
        attacker4.init{value: 1 ether}();     
        vm.prank(user1);
        vm.expectRevert();    
        attacker4.attack();
        vm.writeLine(FILE_NAME, "\ntest_Should_check_result_of_call_to_revert_if_failed_in_abandonMonster");
    }


    /*
        @Topic : SECURITY
        @Score : 10
        @Title : Should prohibit reentrancy issue in claimRaid.
        @Desc  : Test to ensure that claimRaid prohibits reentrancy issues.
    */
    function test_Should_prohibit_reentrancy_issue_in_claimRaid() public {
        // Insert your setup code and the logic to mimic Question1003Attacker5

        vm.prank(user1);
        attacker5.init{value: 1 ether}();
        vm.roll(block.number + 11);
        vm.expectRevert();        
        vm.prank(user1);
        attacker5.attack();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_prohibit_reentrancy_issue_in_claimRaid"
        );
    }

    /*
        @Topic : SECURITY
        @Score : 10
        @Title : Should prohibit reentrancy issue in abandonMonster.
        @Desc  : Test to ensure that abandonMonster prohibits reentrancy issues.
    */
    function test_Should_prohibit_reentrancy_issue_in_abandonMonster() public {
        
        vm.prank(user1);
        attacker6.init{value: 1 ether}();
        vm.expectRevert();        
        vm.prank(user1);
        attacker6.attack();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_prohibit_reentrancy_issue_in_abandonMonster"
        );
    }

}
