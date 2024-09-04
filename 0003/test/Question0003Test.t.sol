// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Question0003Solution} from "../contracts/Question0003Solution.sol"; // Replace with the correct import path

contract Question0003Test is Test {

    string constant FILE_NAME = "test/Question0003Test.t.sol.passed";
    Question0003Solution myToken;
    address owner;
    address addr1;
    address addr2;

    function setUp() public {
        myToken = new Question0003Solution(); // Assuming Question0003Solution has no constructor arguments
        owner = address(this); // In Foundry, the deploying contract is the owner
        addr1 = address(0x1);
        addr2 = address(0x2);
    }

    /*
        @Topic: Basic
        @Score: 100
        @Title: Should mint and burn tokens on transfer
        @Desc: Test to ensure that tokens are minted correctly and that the burn on transfer functionality works as expected.
    */
    function test_Should_Mint_And_Burn_Tokens_On_Transfer() public {
        // Owner mints 1000 tokens to addr1
        myToken.mint(addr1, 1000);
        assertEq(myToken.balanceOf(addr1), 1000);

        // Addr1 transfers 500 tokens to addr2, with a burn fee applied
        vm.prank(addr1);
        myToken.transfer(addr2, 500);
        // Assuming a 15% burn rate for simplicity
        assertEq(myToken.balanceOf(addr1), 500);
        assertEq(myToken.balanceOf(addr2), 425); // 500 - 15% burn

        // Addr1 approves addr2 to spend 100 tokens
        vm.prank(addr1);
        myToken.approve(addr2, 100);

        // Addr2 transfers 100 tokens from addr1 to addr2, with a burn fee applied
        vm.prank(addr2);
        myToken.transferFrom(addr1, addr2, 100);
        // Assuming a 15% burn rate for transfers
        assertEq(myToken.balanceOf(addr1), 400); // 500 - 100 + 15% burn
        assertEq(myToken.balanceOf(addr2), 510); // 425 + 85
        vm.writeLine(
            FILE_NAME,
            "\test_Should_Mint_And_Transfer_Tokens_With_Timelock"
        );
    }
}
