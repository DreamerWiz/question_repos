// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0006Solution.sol"; // Update this import path to your contract's location

contract Question0006Test is Test {
    string constant FILE_NAME = "test/Question0006Test.t.sol.passed";
    Question0006Solution erc721NFT;
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
        erc721NFT = new Question0006Solution();
    }
     /*
        @Topic: Basic
        @Score: 100
        @Title: Should mint NFT and fail to transfer
        @Desc: This test ensures that the NFT can be minted but cannot be transferred, adhering to the non-transferable constraint.
    */
    function test_Basic_ShouldMintNFTAndFailToTransfer() public {
        erc721NFT.createCollectible();

        // Check owner of NFT
        assertEq(erc721NFT.ownerOf(0), owner);

        // Attempt to transfer NFT to another address using transferFrom should fail
        vm.prank(owner);
        vm.expectRevert();
        erc721NFT.transferFrom(owner, addr1, 0);

        // Attempt to transfer NFT to another address using safeTransferFrom without data should fail
        vm.prank(owner);
        vm.expectRevert();
        erc721NFT.safeTransferFrom(owner, addr1, 0);

        // Attempt to transfer NFT to another address using safeTransferFrom with data should fail
        vm.prank(owner);
        vm.expectRevert();
        erc721NFT.safeTransferFrom(owner, addr1, 0, "");

        // Check owner of NFT again, should not change
        assertEq(erc721NFT.ownerOf(0), owner);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Basic_ShouldMintNFTAndFailToTransfer passed");
    }
}
