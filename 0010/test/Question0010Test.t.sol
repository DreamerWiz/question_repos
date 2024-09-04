// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0010Ext.sol"; // Update this import path to your contract's location
import "../contracts/Question0010Solution.sol"; // Update this import path to your contract's location

contract Question0010Test is Test {
    string constant FILE_NAME = "test/Question0010Test.t.sol.passed";
    NFT1 nft1;
    NFT2 nft2;
    Question0010Solution nftExchange;
    address addr1;
    address addr2;

    function setUp() public {
        nft1 = new NFT1();
        nft2 = new NFT2();
        nftExchange = new Question0010Solution();

        addr1 = makeAddr("addr1");
        addr2 = makeAddr("addr2");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Should exchange NFTs between users
        @Desc: Test to ensure that users can exchange NFTs through the NFTExchange contract.
    */
    function test_Should_exchange_nf_ts_between_users() public {
        // User A mints a new NFT from the NFT1 contract
        vm.prank(addr1);
        nft1.createCollectible("https://my-nft.com/1");
        assertEq(nft1.ownerOf(0), addr1);

        // User B mints a new NFT from the NFT2 contract
        vm.prank(addr2);
        nft2.createCollectible("https://my-nft.com/2");
        assertEq(nft2.ownerOf(0), addr2);

        // User A proposes a trade
        vm.prank(addr1);
        nft1.approve(address(nftExchange), 0);
        vm.startPrank(addr1);
        bytes32 tradeId = nftExchange.proposeTrade(address(nft1), 0, address(nft2), 0);
        vm.stopPrank();

        // User B executes the trade
        vm.prank(addr2);
        nft2.approve(address(nftExchange), 0);
        vm.prank(addr2);
        nftExchange.executeTrade(tradeId);

        // Check that the owners of the NFTs have been swapped
        assertEq(nft1.ownerOf(0), addr2);
        assertEq(nft2.ownerOf(0), addr1);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Should_exchange_nf_ts_between_users passed");
    }
}
