// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Question1005Solution} from "../contracts/Question1005Solution.sol";
import {Question1005Attacker1, Question1005Attacker2, Question1005Attacker3, Question1005Attacker4, Question1005Attacker5, Question1005Attacker6} from "../contracts/Question1005Ext.sol";

contract Question1005Test is Test {

    string constant FILE_NAME = "test/Question1005Test.t.sol.passed";

    Question1005Solution socialCards;
    Question1005Attacker1 attacker1;
    Question1005Attacker2 attacker2;
    Question1005Attacker3 attacker3;
    Question1005Attacker4 attacker4;
    Question1005Attacker5 attacker5;
    Question1005Attacker6 attacker6;
    address owner = address(1);
    address addr1 = address(2);
    address addr2 = address(3);
    uint[] presaleAlloc;
    address[] presaleAcc;

    function setUp() public {
        vm.deal(owner, 100 ether);
        vm.deal(addr1, 100 ether);
        vm.deal(addr2, 100 ether);
        vm.warp(1000000);
        socialCards = new Question1005Solution(address(owner));
        attacker1 = new Question1005Attacker1(address(socialCards));
        attacker2 = new Question1005Attacker2(address(socialCards));
        attacker3 = new Question1005Attacker3(address(socialCards));
        attacker4 = new Question1005Attacker4(address(socialCards));
        attacker5 = new Question1005Attacker5(address(socialCards));
        attacker6 = new Question1005Attacker6(address(socialCards));
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should set the right owner */
    /* @Desc  : The test checks if the correct owner is set */
    function test_Should_set_the_right_owner() public {
        assertEq(socialCards.owner(), address(owner));
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_set_the_right_owner"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should set fee destination */
    /* @Desc  : The test checks if the fee destination is set correctly */
    function test_Should_set_fee_destination() public {
        vm.prank(owner);
        socialCards.setFeeDestination(address(addr1));
        assertEq(socialCards.protocolFeeDestination(), address(addr1));
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_set_fee_destination"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should set protocol fee percent */
    /* @Desc  : The test checks if the protocol fee percent is set correctly */
    function test_Should_set_protocol_fee_percent() public {
        vm.prank(owner);
        socialCards.setProtocolFeePercent(500); // 0.005 ether
        assertEq(socialCards.protocolFeePercent(), 500);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_set_protocol_fee_percent"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should set subject fee percent */
    /* @Desc  : The test checks if the subject fee percent is set correctly */
    function test_Should_set_subject_fee_percent() public {
        vm.prank(owner);
        socialCards.setSubjectFeePercent(300); // 0.003 ether
        assertEq(socialCards.subjectFeePercent(), 300);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_set_subject_fee_percent"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should get buy price */
    /* @Desc  : The test checks if the buy price is retrieved correctly */
    function test_Should_get_buy_price() public {
        uint256 buyPrice = socialCards.getBuyPriceAfterFee(address(addr1), 1);
        assertEq(buyPrice, 0); // Replace with exact expected value
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_get_buy_price"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should get sell price */
    /* @Desc  : The test checks if the sell price is retrieved correctly after buying cards */
    function test_Should_get_sell_price() public {
        uint256 buyPrice = socialCards.getBuyPriceAfterFee(address(addr1), 2);
        vm.prank(addr1);
        socialCards.buyCards{value: buyPrice}(address(addr1), 2);
        uint256 sellPrice = socialCards.getSellPriceAfterFee(address(addr1), 1);
        assertEq(sellPrice, buyPrice);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_get_sell_price"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should snipe cards correctly */
    /* @Desc  : The test checks if cards are bought correctly */
    function test_Should_snipe_cards_correctly() public {
        uint price = socialCards.getBuyPriceAfterFee(address(owner), 10);
        vm.prank(owner);
        socialCards.buyCards{value: price}(address(owner), 10);
        assertEq(socialCards.cardsBalance(address(owner), address(owner)), 10);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_snipe_cards_correctly"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should buy cards correctly */
    /* @Desc  : The test checks if cards are bought correctly */
    function test_Should_buy_cards_correctly() public {
        uint price = socialCards.getBuyPriceAfterFee(address(owner), 10);
        vm.prank(owner);
        socialCards.buyCards{value: price}(address(owner), 10);
        assertEq(socialCards.cardsBalance(address(owner), address(owner)), 10);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_buy_cards_correctly"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should sell cards correctly */
    /* @Desc  : The test checks if cards are sold correctly */
    function test_Should_sell_cards_correctly() public {
        uint price = socialCards.getBuyPriceAfterFee(address(owner), 10);
        vm.prank(owner);
        socialCards.buyCards{value: price}(address(owner), 10);
        uint price2 = socialCards.getBuyPriceAfterFee(address(owner), 1);
        vm.prank(addr1);
        socialCards.buyCards{value: price2}(address(owner), 1);
        vm.prank(owner);
        socialCards.sellCards(address(owner), 1);
        assertEq(socialCards.cardsBalance(address(owner), address(addr1)), 1);
        assertEq(socialCards.cardsBalance(address(owner), address(owner)), 9);
        vm.prank(addr1);
        socialCards.sellCards(address(owner), 1);
        assertEq(socialCards.cardsBalance(address(owner), address(addr1)), 0);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_sell_cards_correctly"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should transfer cards correctly */
    /* @Desc  : The test checks if cards are transferred correctly */
    function test_Should_transfer_cards_correctly() public {
        uint price = socialCards.getBuyPriceAfterFee(address(owner), 10);
        vm.prank(owner);
        socialCards.buyCards{value: price}(address(owner), 10);
        vm.prank(owner);
        socialCards.transferCards(address(owner), address(addr1), 5);
        assertEq(socialCards.cardsBalance(address(owner), address(addr1)), 5);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_transfer_cards_correctly"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should approve cards correctly */
    /* @Desc  : The test checks if cards are approved correctly */
    function test_Should_approve_cards_correctly() public {
        uint price = socialCards.getBuyPriceAfterFee(address(owner), 10);
        vm.prank(owner);
        socialCards.buyCards{value: price}(address(owner), 10);
        vm.prank(owner);
        socialCards.approve(address(owner), address(addr1), 5);
        assertEq(
            socialCards.approvals(
                address(owner),
                address(owner),
                address(addr1)
            ),
            5
        );
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_approve_cards_correctly"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should set presale properly */
    /* @Desc  : The test checks if the presale is set correctly */
    function test_Should_set_presale_properly() public {
        presaleAlloc.push(10);
        presaleAlloc.push(20);
        presaleAcc.push(address(addr1));
        presaleAcc.push(address(addr2));
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) + 3600
        );
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_set_presale_properly"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should contribute to presale */
    /* @Desc  : The test checks if contributions to the presale are handled correctly */
    function test_Should_contribute_to_presale() public {
        presaleAlloc.push(10);
        presaleAcc.push(address(addr1));
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) + 3600
        );
        vm.prank(addr1);
        socialCards.contribute{value: 5000}(address(owner), 5);
        assertEq(address(socialCards).balance, 5000);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_contribute_to_presale"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should make cards public */
    /* @Desc  : The test checks if cards are made public correctly */
    function test_Should_make_cards_public() public {
        presaleAlloc.push(10);
        presaleAcc.push(address(addr1));
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) + 3600
        );
        vm.prank(addr1);
        socialCards.contribute{value: 5000}(address(owner), 5);
        uint price = socialCards.getBuyPriceAfterFee(address(owner), 6);
        vm.prank(owner);
        socialCards.publicCards{value: price}();
        assertEq(
            socialCards.cardsBalance(address(owner), address(socialCards)),
            5
        );
        assertEq(socialCards.cardsBalance(address(owner), address(owner)), 1);
        assertEq(socialCards.cardsSupply(address(owner)), 6);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_make_cards_public"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should claim cards */
    /* @Desc  : The test checks if cards are claimed correctly */
    function test_Should_claim_cards() public {
        presaleAlloc.push(10);
        presaleAcc.push(address(addr1));
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) + 360000
        );
        vm.prank(addr1);
        socialCards.contribute{value: 5000}(address(owner), 5);
        uint price = socialCards.getBuyPriceAfterFee(address(owner), 6);
        vm.prank(owner);
        socialCards.publicCards{value: price}();
        vm.prank(addr1);
        socialCards.claimCards(address(owner));
        assertEq(socialCards.cardsBalance(address(owner), address(owner)), 1);
        assertEq(socialCards.cardsBalance(address(owner), address(addr1)), 5);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_claim_cards"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should buyCards correctly after public */
    /* @Desc  : The test checks if cards are bought correctly after being made public */
    function test_Should_buyCards_correctly_after_public() public {
        presaleAlloc.push(10);
        presaleAcc.push(address(addr1));
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) + 3600
        );
        vm.prank(addr1);
        socialCards.contribute{value: 5000}(address(owner), 5);
        uint price = socialCards.getBuyPriceAfterFee(address(owner), 6);
        vm.prank(owner);
        socialCards.publicCards{value: price}();
        vm.prank(addr1);
        socialCards.claimCards(address(owner));
        uint price2 = socialCards.getBuyPriceAfterFee(address(owner), 10);
        vm.prank(owner);
        socialCards.buyCards{value: price2}(address(owner), 10);
        assertEq(socialCards.cardsBalance(address(owner), address(owner)), 11);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_buyCards_correctly_after_public"
        );
    }

    /* @Topic : Basic */
    /* @Score : 5 */
    /* @Title : Should sellCards correctly after public */
    /* @Desc  : The test checks if cards are sold correctly after being made public */
    function test_Should_sellCards_correctly_after_public() public {
        presaleAlloc.push(10);
        presaleAcc.push(address(addr1));
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) + 3600
        );
        vm.prank(addr1);
        socialCards.contribute{value: 5000}(address(owner), 5);
        uint price = socialCards.getBuyPriceAfterFee(address(owner), 6);
        vm.prank(owner);
        socialCards.publicCards{value: price}();
        vm.prank(addr1);
        socialCards.claimCards(address(owner));
        vm.prank(addr1);
        socialCards.sellCards(address(owner), 3);
        assertEq(socialCards.cardsBalance(address(owner), address(addr1)), 2);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_sellCards_correctly_after_public"
        );
    }

    /* @Topic : Detail */
    /* @Score : 5 */
    /* @Title : Should revert setPresale() if presale is already settled */
    /* @Desc : Ensures that setPresale reverts if the presale has already been settled */
    function test_Should_revert_setPresale_if_presale_is_already_settled()
        public
    {
        presaleAlloc.push(10);
        presaleAlloc.push(20);
        presaleAcc.push(address(addr1));
        presaleAcc.push(address(addr2));
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) + 3600
        );
        vm.expectRevert();
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) + 3600
        );
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_setPresale_if_presale_is_already_settled"
        );
    }

    /* @Topic : Detail */
    /* @Score : 5 */
    /* @Title : Should revert contribute() if presale is not available */
    /* @Desc : Ensures that contribute reverts if the presale is not available */
    function test_Should_revert_contribute_if_presale_is_not_available()
        public
    {
        presaleAlloc.push(10);
        presaleAlloc.push(20);
        presaleAcc.push(address(addr1));
        presaleAcc.push(address(addr2));
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) + 3600
        );
        vm.prank(owner);
        socialCards.publicCards();
        vm.prank(addr1);
        vm.expectRevert();
        socialCards.contribute(address(owner), 1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_contribute_if_presale_is_not_available"
        );
    }

    /* @Topic : Detail */
    /* @Score : 5 */
    /* @Title : Should revert publicCards() if presale is not available */
    /* @Desc : Ensures that publicCards reverts if the presale is not available */
    function test_Should_revert_publicCards_if_presale_is_not_available()
        public
    {
        vm.prank(owner);
        vm.expectRevert();
        socialCards.publicCards();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_publicCards_if_presale_is_not_available"
        );
    }

    /* @Topic : Detail */
    /* @Score : 5 */
    /* @Title : Should revert claimCards() if presale is not public */
    /* @Desc : Ensures that claimCards reverts if the presale is not public */
    function test_Should_revert_claimCards_if_presale_is_not_public() public {
        presaleAlloc.push(10);
        presaleAlloc.push(20);
        presaleAcc.push(address(addr1));
        presaleAcc.push(address(addr2));
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) - 3600
        );
        vm.prank(addr1);
        vm.expectRevert();
        socialCards.claimCards(address(owner));
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_claimCards_if_presale_is_not_public"
        );
    }

    /* @Topic : Detail */
    /* @Score : 5 */
    /* @Title : Should revert buyCards() if presale is not public */
    /* @Desc : Ensures that buyCards reverts if the presale is not public */
    function test_Should_revert_buyCards_if_presale_is_not_public() public {
        presaleAlloc.push(10);
        presaleAlloc.push(20);
        presaleAcc.push(address(addr1));
        presaleAcc.push(address(addr2));
        vm.prank(owner);
        socialCards.setPresale(
            presaleAcc,
            presaleAlloc,
            1000,
            uint32(block.timestamp) + 3600
        );
        vm.prank(addr1);
        vm.expectRevert();
        socialCards.buyCards(address(owner), 1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_buyCards_if_presale_is_not_public"
        );
    }

    /* @Topic : Detail */
    /* @Score : 5 */
    /* @Title : Should revert buyCards() if not enough eth */
    /* @Desc : Ensures that buyCards reverts if there's not enough ether */
    function test_Should_revert_buyCards_if_not_enough_eth() public {
        vm.prank(owner);
        socialCards.buyCards(address(owner), 1);
        vm.prank(addr1);
        vm.expectRevert();
        socialCards.buyCards(address(owner), 1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_buyCards_if_not_enough_eth"
        );
    }

    /* @Topic : Detail */
    /* @Score : 5 */
    /* @Title : Should revert sellCards() if not enough cards */
    /* @Desc : Ensures that sellCards reverts if there's not enough cards */
    function test_Should_revert_sellCards_if_not_enough_cards() public {
        vm.prank(addr1);
        vm.expectRevert();
        socialCards.sellCards(address(owner), 1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_sellCards_if_not_enough_cards"
        );
    }

    /* @Topic : Detail */
    /* @Score : 5 */
    /* @Title : Should revert sellCards() if sell the last one own card */
    /* @Desc : Ensures that sellCards reverts if trying to sell the last owned card */
    function test_Should_revert_sellCards_if_sell_the_last_one_own_card()
        public
    {
        vm.prank(owner);
        socialCards.buyCards(address(owner), 1);
        vm.expectRevert();
        vm.prank(owner);
        socialCards.sellCards(address(owner), 1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_revert_sellCards_if_sell_the_last_one_own_card"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 5 */
    /* @Title: Should use .call to transfer ETH in buyCards rather than .transfer to support proxy contracts */
    /* @Desc: Validates the use of .call over .transfer in buyCards to support proxy contracts */
    function test_Should_Use_Call_In_Buy_Cards() public {
        attacker1.attack{value: 1000 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Use_Call_In_Buy_Cards"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 5 */
    /* @Title: Should use .call to transfer ETH in sellCards rather than .transfer to support proxy contracts */
    /* @Desc: Validates the use of .call over .transfer in sellCards to support proxy contracts */
    function test_Should_Use_Call_In_Sell_Cards() public {
        attacker2.attack{value: 1000 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Use_Call_In_Sell_Cards"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 5 */
    /* @Title: Should check the result of .call function to revert if failed in buyCards */
    /* @Desc: Validates that the result of the .call function is checked to revert if failed in buyCards */
    function test_Should_Check_Call_Result_In_Buy_Cards() public {
        vm.expectRevert();
        attacker3.attack{value: 1000 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Check_Call_Result_In_Buy_Cards"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 5 */
    /* @Title: Should check the result of .call function to revert if failed in sellCards */
    /* @Desc: Validates that the result of the .call function is checked to revert if failed in sellCards */
    function test_Should_Check_Call_Result_In_Sell_Cards() public {
        vm.expectRevert();
        attacker4.buy{value: 1000 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Check_Call_Result_In_Sell_Cards"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 5 */
    /* @Title: Should prohibit reentrancy issue in buyCards */
    /* @Desc: Validates that reentrancy issues are prohibited in buyCards */
    function test_Should_Prohibit_Reentrancy_In_Buy_Cards() public {
        vm.expectRevert();
        attacker5.attack{value: 1000 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Prohibit_Reentrancy_In_Buy_Cards"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 5 */
    /* @Title: Should prohibit reentrancy issue in sellCards */
    /* @Desc: Validates that reentrancy issues are prohibited in sellCards */
    function test_Should_Prohibit_Reentrancy_In_Sell_Cards() public {
        vm.expectRevert();
        attacker6.attack{value: 1000 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Prohibit_Reentrancy_In_Sell_Cards"
        );
    }
}
