// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Question0004Solution} from "../contracts/Question0004Solution.sol"; // Update the path to where your contract is actually located

contract Question0004Test is Test {
    string constant FILE_NAME = "test/Question0004Test.t.sol.passed";
    Question0004Solution nft;
    address deployer;
    address addr1;
    address addr2;
    uint256 mintingFee = 0.01 ether; // Set minting fee to 0.01 ETH

    function setUp() public {
        deployer = address(this);
        addr1 = address(0x1);
        addr2 = address(0x2);
        vm.deal(deployer, 100 ether);
        vm.deal(addr1, 200 ether);
        vm.deal(addr2, 200 ether);
        nft = new Question0004Solution(mintingFee);
    }
    /*
        @Topic: Basic
        @Score: 100
        @Title: Should mint NFT if enough fee is paid and refund excess payment
        @Desc: This test ensures that NFTs can only be minted if the correct fee is paid and that any excess payment is refunded.
    */
    function test_Should_mint_nft_if_enough_fee_is_paid_and_refund_excess_payment() public {
        // B tries to mint NFT with insufficient fee
        vm.prank(addr1);
        vm.expectRevert();
        nft.createCollectible{value: 0.005 ether}("https://my-nft.com/1");

        // C mints NFT with exact fee
        uint256 addr2InitialBalance = addr2.balance;
        vm.startPrank(addr2);
        nft.createCollectible{value: 0.01 ether}("https://my-nft.com/2");
        
        // Check owner of NFT
        address nftOwner = nft.ownerOf(0);
        assertEq(nftOwner, addr2);

        // C mints NFT with excess fee
        uint256 excessPayment = 0.01 ether; // Excess payment of 0.01 ETH

        nft.createCollectible{value: mintingFee + excessPayment}("https://my-nft.com/3");

        
        // Check owner of NFT
        nftOwner = nft.ownerOf(1);
        assertEq(nftOwner, addr2);

        // Check if C's balance is correct (initial balance - gas used - minting fee)
        uint256 addr2FinalBalance = address(addr2).balance;
        assertEq(addr2FinalBalance, addr2InitialBalance - 2 * mintingFee);
        vm.stopPrank();

        // Write a success line to a file
        vm.writeLine(FILE_NAME, "test_Should_mint_nft_if_enough_fee_is_paid_and_refund_excess_payment passed");
    }
}
