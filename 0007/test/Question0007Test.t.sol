// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0007Solution.sol"; // Update this import path to your contract's location

contract Question0007Test is Test {
    string constant FILE_NAME = "test/Question0007Test.t.sol.passed";
    Question0007Solution myERC1155;
    address owner;
    address addr1;
    address addr2;
    uint256 mintingFee = 0.01 ether; // Set minting fee to 0.01 ETH

    function setUp() public {
        owner = address(this);
        addr1 = address(0x1);
        addr2 = address(0x2);
        vm.deal(owner, 100 ether);
        vm.deal(addr1, 200 ether);
        vm.deal(addr2, 200 ether);
        vm.prank(owner);
        myERC1155 = new Question0007Solution();
    }
    /*
        @Topic: Basic
        @Score: 100
        @Title: User mints an item with exact fee
        @Desc: This test ensures that users can mint an item with the exact minting fee and receive the correct balance.
    */
    function test_Basic_UserMintsItemWithExactFee() public {
        vm.prank(addr1);
        myERC1155.mintItem{value: 0.01 ether}();
        assertEq(myERC1155.balanceOf(addr1, 0), 1);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Basic_UserMintsItemWithExactFee passed");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: User mints an item with extra fee, should be refunded
        @Desc: This test checks that when a user mints an item with an extra fee, the excess amount is refunded.
    */
    function test_Basic_UserMintsItemWithExtraFeeShouldBeRefunded() public {
        uint256 startBalance = addr1.balance;
        vm.prank(addr1);
        myERC1155.mintItem{value: 0.02 ether}();
        assertEq(myERC1155.balanceOf(addr1, 0), 1);
        uint256 endBalance = addr1.balance;
        assertEq(endBalance + (0.01 ether) , startBalance);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Basic_UserMintsItemWithExtraFeeShouldBeRefunded passed");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: User refunds an item after 6 days
        @Desc: This test ensures that a user can refund an item within the specified refund period (e.g., 6 days).
    */
    function test_Basic_UserRefundsItemAfter6Days() public {
        vm.prank(addr1);
        myERC1155.mintItem{value: 0.02 ether}();
        vm.warp(block.timestamp + 6 days);
        vm.prank(addr1);
        myERC1155.refundItem();
        assertEq(myERC1155.balanceOf(addr1, 0), 0);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Basic_UserRefundsItemAfter6Days passed");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: User refunds an item after 8 days, should fail
        @Desc: This test verifies that attempting to refund an item after the refund period (e.g., 8 days) has expired results in failure.
    */
    function test_Basic_UserRefundsItemAfter8DaysShouldFail() public {
        vm.prank(addr1);
        myERC1155.mintItem{value: 0.02 ether}();
        vm.warp(block.timestamp + 8 days);
        vm.prank(addr1);
        vm.expectRevert();
        myERC1155.refundItem();

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Basic_UserRefundsItemAfter8DaysShouldFail passed");
    }
}
