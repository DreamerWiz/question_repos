// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0008Solution.sol"; // Update this import path to your contract's location

contract Question0008Test is Test {
    string constant FILE_NAME = "test/Question0008Test.t.sol.passed";
    Question0008Solution myERC1155;
    address owner;

    function setUp() public {
        owner = address(1);
        vm.deal(owner, 100 ether);
        myERC1155 = new Question0008Solution();
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Owner tries to mint an item with insufficient Ether and should fail
        @Desc: Ensure that minting an item with less than the required minting fee leads to a transaction revert.
    */
    function test_Should_owner_mints_item_with_insufficient_ether_should_fail() public {
        vm.expectRevert();
        vm.prank(owner);
        myERC1155.mintItem{value: 0.005 ether}();

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Should_owner_mints_item_with_insufficient_ether_should_fail passed");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Owner mints an item with 0.02 Ether
        @Desc: Validate that the owner can mint an item with a specific Ether amount and the contract balance updates correctly.
    */
    function test_Should_owner_mints_item_with_exact_ether() public {
        vm.prank(owner);
        uint256 mintingFee = 0.01 ether;
        myERC1155.mintItem{value: 0.02 ether}();
        assertEq(myERC1155.balanceOf(owner, 0), 1);

        // Check contract balance
        assertEq(address(myERC1155).balance, mintingFee);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Should_owner_mints_item_with_exact_ether passed");
    }
}
