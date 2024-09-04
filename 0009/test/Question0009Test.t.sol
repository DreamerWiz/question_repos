// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0009Solution.sol"; // Update this import path to your contract's location
import "../contracts/Question0009Ext.sol"; // Update this import path to your contract's location

contract Question0009Test is Test {
    string constant FILE_NAME = "test/Question0009Test.t.sol.passed";
    Question0009Solution myERC1155;
    MyERC721 myERC721;
    address owner;
    address addr1;

    function setUp() public {
        owner = address(1);
        addr1 = makeAddr("addr1");
        vm.deal(owner, 100 ether);
        vm.deal(addr1, 100 ether);
        vm.startPrank(owner);
        myERC721 = new MyERC721();
        myERC1155 = new Question0009Solution(address(myERC721));
        vm.stopPrank();
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Should mint and check ownership correctly
        @Desc: Validate that the owner can mint both ERC721 and ERC1155 tokens and the ownership is assigned correctly.
    */
    function testBasic_ShouldMintAndCheckOwnershipCorrectly() public {
        // Owner mints a MyERC721 token
        vm.startPrank(owner);
        myERC721.mintItem{value: 0.01 ether}();
        assertEq(myERC721.balanceOf(owner), 1);

        // Owner mints a MyERC1155 token
        myERC1155.mintItem(0, 100);
        assertEq(myERC1155.balanceOf(owner, 0), 100);

        vm.stopPrank();
        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "testBasic_ShouldMintAndCheckOwnershipCorrectly passed");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Should mint failed with the same ERC721 token id
        @Desc: Ensure that minting an ERC1155 token with an already used ERC721 token id leads to a transaction revert.
    */
    function testBasic_ShouldMintFailWithSameERC721TokenId() public {
        // Owner tries to mint another MyERC1155 token with the same ERC721 token and fails
        vm.expectRevert();
        vm.prank(owner);
        myERC1155.mintItem(0, 100);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "testBasic_ShouldMintFailWithSameERC721TokenId passed");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Should mint fail without ERC721 token
        @Desc: Confirm that an address without a corresponding ERC721 token cannot mint an ERC1155 token.
    */
    function testBasic_ShouldMintFailWithoutERC721Token() public {
        // Addr1 tries to mint a MyERC1155 token and fails
        vm.prank(addr1);
        vm.expectRevert();
        myERC1155.mintItem(0, 100);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "testBasic_ShouldMintFailWithoutERC721Token passed");
    }
}
