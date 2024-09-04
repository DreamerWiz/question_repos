// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Question0001Solution} from "../contracts/Question0001Solution.sol";

contract Question0001Test is Test {
    string constant FILE_NAME = "test/Question0001Test.t.sol.passed";
    Question0001Solution myToken;
    address owner;
    address addr1;
    address addr2;
    address addr3;

    function setUp() public {
        myToken = new Question0001Solution(); // Assuming Question0001Solution has no constructor arguments
        owner = address(this); // In Foundry, the deploying contract is the owner
        addr1 = address(0x1);
        addr2 = address(0x2);
        addr3 = address(0x3);
    }
    /*
        @Topic : Basic
        @Score : 100
        @Title : Should mint and transfer tokens
        @Desc  : Test to ensure that only the owner can mint and user can transfer tokens.
    */
    function test_Should_Mint_And_Transfer_Tokens() public {
        // Owner mints 1000 tokens to addr1
        myToken.mint(addr1, 1000);
        assertEq(myToken.balanceOf(addr1), 1000);

        // Addr1 fails to mint tokens - expecting revert
        vm.prank(addr1); // Set the next call to come from addr1
        vm.expectRevert("Ownable: caller is not the owner");
        myToken.mint(addr1, 1000);

        // Addr1 transfers 500 tokens to addr2
        vm.prank(addr1);
        myToken.transfer(addr2, 500);
        assertEq(myToken.balanceOf(addr1), 500);
        assertEq(myToken.balanceOf(addr2), 500);

        // Addr1 approves 100 tokens to addr2
        vm.prank(addr1);
        myToken.approve(addr2, 100);
        assertEq(myToken.allowance(addr1, addr2), 100);

        // Addr2 transfers 50 approved tokens from Addr1 to Addr3
        vm.prank(addr2);
        myToken.transferFrom(addr1, addr3, 50);
        assertEq(myToken.balanceOf(addr1), 450);
        assertEq(myToken.balanceOf(addr3), 50);
        assertEq(myToken.allowance(addr1, addr2), 50);
        vm.writeLine(
            FILE_NAME,
            "\test_Should_Mint_And_Transfer_Tokens"
        );
    }
}
