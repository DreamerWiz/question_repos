// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Question1006Solution} from "../contracts/Question1006Solution.sol";
import {MockERC20, Question1006Attacker1, Question1006Attacker2, Question1006Attacker3, Question1006Attacker4, Question1006Attacker5, Question1006Attacker6} from "../contracts/Question1006Ext.sol";

contract Question1006Test is Test {
    string constant FILE_NAME = "test/Question1006Test.t.sol.passed";
    enum AuctionState {
        None,
        SETTELED,
        CANCELED,
        ENDED
    }
    Question1006Solution auction;
    MockERC20 token;
    Question1006Attacker1 attacker1;
    Question1006Attacker2 attacker2;
    Question1006Attacker3 attacker3;
    Question1006Attacker4 attacker4;
    Question1006Attacker5 attacker5;
    Question1006Attacker6 attacker6;
    address owner = address(1);
    address user1 = address(2);
    address user2 = address(3);
    uint256 auctionId = 1;
    uint256 startPrice = 0.1 ether ;
    uint256 endPrice = 0.01 ether;
    uint256 startTime = block.timestamp + 1 days;
    uint256 endTime = block.timestamp + 2 days;
    uint256 tokenAmount = 1000;

    function setUp() public {
        vm.deal(owner, 100 ether);
        vm.deal(user1, 200 ether);
        vm.deal(user2, 200 ether);
        // vm.warp(1000000);
        auction = new Question1006Solution(owner);
        token = new MockERC20();
        attacker1 = new Question1006Attacker1(address(auction));
        attacker2 = new Question1006Attacker2(address(auction), address(token));
        attacker3 = new Question1006Attacker3(address(auction));
        attacker4 = new Question1006Attacker4(address(auction), address(token));
        attacker5 = new Question1006Attacker5(address(auction));
        attacker6 = new Question1006Attacker6(address(auction), address(token));

        token.mint(address(user2), 1000 ether);
        token.mint(address(attacker2), 1000 ether);
        token.mint(address(attacker4), 1000 ether);
        token.mint(address(attacker6), 1000 ether);
        vm.prank(user2);
        token.approve(address(auction), 1000 ether);
    }

    // /* @Topic : Basic */
    // /* @Score : 5 */
    // /* @Title : Should create auction successfully */
    // /* @Desc  : The test if create auction succesfully */
    function test_Should_create_auction_successfully() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );
        Question1006Solution.Auction memory info = auction.getAuctionInfo(1);
        assertEq(info.startPrice, startPrice);
        assertEq(info.endPrice, endPrice);
        assertEq(info.startTime, startTime);
        assertEq(info.endTime, endTime);
        assertEq(info.depositedTokens, tokenAmount);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_create_auction_successfully"
        );
    }

    // /* @Topic : Basic */
    // /* @Score : 5 */
    // /* @Title : Should cancel auction successfully */
    // /* @Desc  : The test if cancel auction successfully */
    function test_Should_cancel_auction_successfully() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );

        // End auction and claim profit
        vm.prank(user2);
        auction.cancelAuction(auctionId);

        // Verify state changes
        Question1006Solution.Auction memory info = auction.getAuctionInfo(
            auctionId
        );
        assertEq(
            uint256(info.state),
            uint256(AuctionState.CANCELED)
        );
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_cancel_auction_successfully"
        );
    }

    // /* @Topic : Basic */
    // /* @Score : 5 */
    // /* @Title : Should bid successfully */
    // /* @Desc  : The test if bid successfully */
    function test_Should_bid_successfully() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );
        vm.warp(startTime + 30);
        // Place a bid
        auction.bid{value: 2 ether}(auctionId);

        uint256 currentPrice = auction.getCurrentPrice(auctionId);
        assertTrue(currentPrice >= 0.01 ether && currentPrice <= 0.1 ether);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_bid_successfully"
        );
    }

    // /* @Topic : Basic */
    // /* @Score : 5 */
    // /* @Title : Should end auction and claim profit successfully */
    // /* @Desc  : The test if end auction and claim profit successfully */
    function test_Should_end_auction_and_claim_profit_successfully() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );
        vm.warp(block.timestamp + 1 days + 30);

        // Place a bid
        vm.prank(user1);
        auction.bid{value: 2 ether}(auctionId);

        vm.warp(block.timestamp + 1 days + 30);
        // End auction and claim profit
        vm.prank(user2);
        auction.endAuctionAndClaimProfit(auctionId);

        // Verify state changes
        Question1006Solution.Auction memory info = auction.getAuctionInfo(
            auctionId
        );
        assertEq(
            uint256(info.state),
            uint256(AuctionState.ENDED)
        );
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_end_auction_and_claim_profit_successfully"
        );
    }

    // /* @Topic : Basic */
    // /* @Score : 5 */
    // /* @Title : Should claim tokens successfully */
    // /* @Desc  : The test if claim tokens successfully */
    function test_Should_claim_tokens_successfully() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );

        vm.warp(block.timestamp + 1 days + 30);

        vm.prank(user1);
        // Place a bid
        auction.bid{value: 2 ether}(auctionId);

        vm.warp(block.timestamp + 2 days + 30);
        // End auction and claim profit
        vm.prank(user2);
        auction.endAuctionAndClaimProfit(auctionId);
        // Claim tokens
        vm.prank(user1);
        auction.claimTokens(auctionId);
        uint bal_after = token.balanceOf(user1);

        assertEq(bal_after, 2 ether/endPrice);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_claim_tokens_successfully"
        );

    }
    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test isAuctionLive works as expected */
    /* @Desc  : The test to check if isAuctionLive returns correct values */
    function test_isAuctionLive_works_as_expected() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );
        vm.warp(block.timestamp + 1 days + 30);
        assertTrue(auction.isAuctionLive(auctionId));
        vm.writeLine(
            FILE_NAME,
            "\ntest_isAuctionLive_works_as_expected"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test createAuction price require check */
    /* @Desc  : The test to check if createAuction validates price requirements */
    function test_createAuction_price_require_check() public {

        vm.prank(user2);
        vm.expectRevert();
        auction.createAuction(
            address(token),
            endPrice,
            startPrice,
            startTime,
            endTime,
            tokenAmount
        );
        vm.writeLine(
            FILE_NAME,
            "\ntest_createAuction_price_require_check"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test createAuction time require check */
    /* @Desc  : The test to check if createAuction validates time requirements */
    function test_createAuction_time_require_check() public {
        vm.prank(user2);
        vm.expectRevert();
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            endTime,
            startTime,
            tokenAmount
        );
        vm.writeLine(
            FILE_NAME,
            "\ntest_createAuction_time_require_check"
        );
    }
    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test createAuction token address require check */
    /* @Desc  : The test to check if createAuction validates token address requirements */
    function test_createAuction_token_address_require_check() public {
        vm.prank(user2);
        vm.expectRevert();
        auction.createAuction(
            address(0),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );
        vm.writeLine(
            FILE_NAME,
            "\ntest_createAuction_token_address_require_check"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test createAuction tokenAmount require check */
    /* @Desc  : The test to check if createAuction validates tokenAmount requirements */
    function test_createAuction_tokenAmount_require_check() public {
        vm.prank(user2);
        vm.expectRevert();
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            0
        );
        vm.writeLine(
            FILE_NAME,
            "\ntest_createAuction_tokenAmount_require_check"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test createAuction token transfer require check */
    /* @Desc  : The test to check if createAuction handles token transfers correctly */
    function test_createAuction_token_transfer_require_check() public {
        vm.prank(user2);
        token.decreaseAllowance(address(auction), 1);
        vm.expectRevert();
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );
        vm.writeLine(
            FILE_NAME,
            "\ntest_createAuction_token_transfer_require_check"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test cancelAuction can only be called by the auction owner */
    /* @Desc  : The test to check if cancelAuction validates the auction owner */
    function test_cancelAuction_can_only_be_called_by_the_auction_owner() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.expectRevert();
        auction.cancelAuction(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_cancelAuction_can_only_be_called_by_the_auction_owner"
        );
    }
     /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test cancelAuction can only be called while settled state */
    /* @Desc  : The test to check if cancelAuction can only be called in the settled state */
    function test_cancelAuction_can_only_be_called_while_settled_state() public {
        vm.expectRevert();
        auction.cancelAuction(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_cancelAuction_can_only_be_called_while_settled_state"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test cancelAuction can only be called before startTime */
    /* @Desc  : The test to check if cancelAuction can only be called before the auction starts */
    function test_cancelAuction_can_only_be_called_before_startTime() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.expectRevert();
        vm.warp(startTime + 1);
        auction.cancelAuction(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_cancelAuction_can_only_be_called_before_startTime"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test cancelAuction token transfer require check */
    /* @Desc  : The test to check if cancelAuction handles token transfer correctly */
    function test_cancelAuction_token_transfer_require_check() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );                
        vm.prank(user2);
        auction.cancelAuction(auctionId);
        assertEq(token.balanceOf(user2), tokenAmount* 1 ether);
        vm.writeLine(
            FILE_NAME,
            "\ntest_cancelAuction_token_transfer_require_check"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test bid can only be called while settled state */
    /* @Desc  : The test to check if bid can only be called in a settled state */
    function test_bid_can_only_be_called_while_settled_state() public {
        vm.expectRevert();
        vm.prank(user1);
        auction.bid{value: 2 ether}(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_bid_can_only_be_called_while_settled_state"
        );
    }
     /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test bid excess eth transfer require check */
    /* @Desc  : The test to check if excess eth is handled correctly in bidding */
    function test_bid_excess_eth_transfer_require_check() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(startTime + 1);
        vm.prank(user1);
        auction.bid{value: 101 ether}(auctionId);
        assertEq(user1.balance, 200 ether - tokenAmount * auction.getCurrentPrice(auctionId));
        vm.writeLine(
            FILE_NAME,
            "\ntest_bid_excess_eth_transfer_require_check"
        );
    }
    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test bid can only be called while auction is live */
    /* @Desc  : The test to check if bid function is accessible only while the auction is live */
    function test_bid_can_only_be_called_while_auction_is_live() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.prank(user1);
        vm.expectRevert();
        auction.bid{value: 101 ether}(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_bid_can_only_be_called_while_auction_is_live"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test endAuctionAndClaimProfit can only be called while setteled state */
    /* @Desc  : The test to check if ending auction and claiming profit can only be done in a settled state */
    function test_endAuctionAndClaimProfit_can_only_be_called_while_settled_state() public {
        vm.prank(user1);
        vm.expectRevert();
        auction.endAuctionAndClaimProfit(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_endAuctionAndClaimProfit_can_only_be_called_while_settled_state"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test endAuctionAndClaimProfit can only be called while auction is not live */
    /* @Desc  : The test to check if ending auction and claiming profit can only be done while the auction is not live */
    function test_endAuctionAndClaimProfit_can_only_be_called_while_auction_is_not_live() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(startTime + 1);
        vm.prank(user1);
        vm.expectRevert();
        auction.endAuctionAndClaimProfit(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_endAuctionAndClaimProfit_can_only_be_called_while_auction_is_not_live"
        );
    }
    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test endAuctionAndClaimProfit can only be called by the auction owner */
    /* @Desc  : The test to ensure only the auction owner can end the auction and claim profits */
    function test_endAuctionAndClaimProfit_can_only_be_called_by_the_auction_owner() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(endTime + 1);
        vm.prank(user1);
        vm.expectRevert();
        auction.endAuctionAndClaimProfit(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_endAuctionAndClaimProfit_can_only_be_called_by_the_auction_owner"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test endAuctionAndClaimProfit surplus token transfer require check */
    /* @Desc  : The test to check if surplus tokens are transferred correctly when ending the auction */
    function test_endAuctionAndClaimProfit_surplus_token_transfer_require_check() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(endTime + 1);
        vm.prank(user2);
        auction.endAuctionAndClaimProfit(auctionId);
        assertEq(token.balanceOf(user2), tokenAmount * 1 ether);
        vm.writeLine(
            FILE_NAME,
            "\ntest_endAuctionAndClaimProfit_surplus_token_transfer_require_check"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test endAuctionAndClaimProfit eth profit splitting check */
    /* @Desc  : The test to check if the eth profit is correctly split when ending the auction */
    function test_endAuctionAndClaimProfit_eth_profit_splitting_check() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(startTime + 1);
        vm.prank(user1);
        auction.bid{value: 0.1 ether}(auctionId);
        vm.warp(endTime + 1);
        vm.prank(user2);
        auction.endAuctionAndClaimProfit(auctionId);
        assertEq(user2.balance, 200.09 ether);
        vm.writeLine(
            FILE_NAME,
            "\ntest_endAuctionAndClaimProfit_eth_profit_splitting_check"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test claimTokens can only be called while ended state */
    /* @Desc  : The test to check if tokens can only be claimed when the auction is ended */
    function test_claimTokens_can_only_be_called_while_ended_state() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(startTime + 1);
        vm.prank(user1);
        auction.bid{value: 0.1 ether}(auctionId);
        vm.warp(endTime + 1);
        vm.prank(user1);
        vm.expectRevert();
        auction.claimTokens(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_claimTokens_can_only_be_called_while_ended_state"
        );
    }

    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test claimTokens bid amount require check */
    /* @Desc  : The test to check if the correct bid amount is required to claim tokens */
    function test_claimTokens_bid_amount_require_check() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(endTime + 1);
        vm.prank(user2);
        auction.endAuctionAndClaimProfit(auctionId);
        vm.prank(user1);
        vm.expectRevert();
        auction.claimTokens(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_claimTokens_bid_amount_require_check"
        );
    }


    /* @Topic : Detail */
    /* @Score : 3 */
    /* @Title : Test claimTokens can only be called while auction is not live */
    /* @Desc  : The test to check if tokens can only be claimed when the auction is not live */
    function test_claimTokens_can_only_be_called_while_auction_is_not_live() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(startTime + 1);
        vm.prank(user1);
        auction.bid{value: 0.1 ether}(auctionId);
        vm.prank(user1);
        vm.expectRevert();
        auction.claimTokens(auctionId);
        vm.writeLine(
            FILE_NAME,
            "\ntest_claimTokens_can_only_be_called_while_auction_is_not_live"
        );
    }
    /* @Topic: SECURITY */
    /* @Score: 6 */
    /* @Title: Should use .call to transfer ETH in bid rather than .transfer to support proxy contracts */
    /* @Desc: Validates the use of .call over .transfer in bid to support proxy contracts */
    function test_Should_Use_Call_In_Bid() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(startTime + 1);
        vm.prank(user1);
        attacker1.attack{value: 102 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Use_Call_In_Bid"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 6 */
    /* @Title: Should use .call to transfer ETH in endAuction rather than .transfer to support proxy contracts */
    /* @Desc: Validates the use of .call over .transfer in endAuction to support proxy contracts */
    function test_Should_Use_Call_In_End_Auction() public {
        vm.prank(user2);
        attacker2.init();
        vm.warp(endTime + 1);
        vm.prank(user2);
        attacker2.attack();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Use_Call_In_End_Auction"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 6 */
    /* @Title: Should check the result of .call function to revert if failed in bid */
    /* @Desc: Validates that the result of the .call function is checked to revert if failed in bid */
    function test_Should_Check_Call_Result_In_Bid() public {        
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(startTime + 1);
        vm.prank(user1);
        vm.expectRevert();
        attacker3.attack{value: 102 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Check_Call_Result_In_Bid"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 6 */
    /* @Title: Should check the result of .call function to revert if failed in endAuction */
    /* @Desc: Validates that the result of the .call function is checked to revert if failed in endAuction */
    function test_Should_Check_Call_Result_In_End_Auction() public {
        vm.prank(user2);
        attacker2.init();
        vm.warp(endTime + 1);
        vm.expectRevert();
        vm.prank(user2);
        attacker4.attack();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Check_Call_Result_In_End_Auction"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 6 */
    /* @Title: Should prohibit reentrancy issue in bid */
    /* @Desc: Validates that reentrancy issues are prohibited in bid */
    function test_Should_Prohibit_Reentrancy_In_Bid() public {
        vm.prank(user2);
        auction.createAuction(
            address(token),
            startPrice,
            endPrice,
            startTime,
            endTime,
            tokenAmount
        );        
        vm.warp(startTime + 1);
        vm.prank(user1);
        vm.expectRevert();
        attacker5.attack{value: 102 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Prohibit_Reentrancy_In_Bid"
        );
    }

    /* @Topic: SECURITY */
    /* @Score: 6 */
    /* @Title: Should prohibit reentrancy issue in endAuction */
    /* @Desc: Validates that reentrancy issues are prohibited in endAuction */
    function test_Should_Prohibit_Reentrancy_In_End_Auction() public {
        vm.prank(user2);
        attacker2.init();
        vm.warp(endTime + 1);
        vm.expectRevert();
        vm.prank(user2);
        attacker6.attack();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_Prohibit_Reentrancy_In_End_Auction"
        );
    }
}
