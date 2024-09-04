// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/Question0005Solution.sol"; // Update this import path to your contract's location

contract Question0005Test is Test {
    string constant FILE_NAME = "test/Question0005Test.t.sol.passed";
    Question0005Solution nft;
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
        nft = new Question0005Solution(mintingFee);
    }
        /*
        @Topic: Basic
        @Score: 100
        @Title: Should mint NFT if enough fee is paid
        @Desc: This test ensures that the NFT cannot be minted if the minting fee is not met, enforcing the correct fee requirement.
    */
    function test_Basic_ShouldMintNFTIfEnoughFeeIsPaid() public {
        vm.prank(addr1);
        vm.expectRevert();
        nft.createCollectible{value: 0.005 ether}("https://my-nft.com/1");

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Basic_ShouldMintNFTIfEnoughFeeIsPaid passed");
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Should mint first NFT and tokenId is 0
        @Desc: This test checks that the first NFT minted receives the tokenId of 0 and is owned by the correct address.
    */
    function test_Basic_ShouldMintFirstNFTAndTokenIdIs0() public {
        vm.prank(addr2);
        nft.createCollectible{value: mintingFee}("https://my-nft.com/2");
        vm.prank(addr2);
        nft.createCollectible{value: mintingFee}("https://my-nft.com/3");

        assertEq(nft.ownerOf(0), addr2);
        assertEq(nft.ownerOf(1), addr2);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Basic_ShouldMintFirstNFTAndTokenIdIs0 passed");
    }

    /*
        @Topic: Detail
        @Score: 100
        @Title: Should reject if paid ETH is not enough
        @Desc: This test verifies that the contract rejects the transaction when the ETH sent is less than the minting fee.
    */
    function test_Detail_ShouldRejectIfPaidETHIsNotEnough() public {
        vm.prank(addr2);
        vm.expectRevert();
        nft.createCollectible{value: mintingFee - 1}("https://my-nft.com/2");

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Detail_ShouldRejectIfPaidETHIsNotEnough passed");
    }

    /*
        @Topic: Detail
        @Score: 100
        @Title: Should contract receive correct ETH
        @Desc: This test ensures that the contract's balance reflects the correct amount of ETH after minting fees are paid.
    */
    function test_Detail_ShouldContractReceiveCorrectETH() public {
        vm.prank(addr2);
        nft.createCollectible{value: mintingFee + 1}("https://my-nft.com/2");
        vm.prank(addr2);
        nft.createCollectible{value: mintingFee}("https://my-nft.com/3");

        assertEq(address(nft).balance, mintingFee * 2);

        // Log the passing of the test to a file
        vm.writeLine(FILE_NAME, "test_Detail_ShouldContractReceiveCorrectETH passed");
    }
}
