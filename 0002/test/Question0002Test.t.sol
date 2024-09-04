// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Question0002Solution} from "../contracts/Question0002Solution.sol";

contract Question0002Test is Test {
    string constant FILE_NAME = "test/Question0002Test.t.sol.passed";
    Question0002Solution myToken;
    address owner;
    address addr1;
    address addr2;

    function setUp() public {
        myToken = new Question0002Solution(); // Assuming MyTimeLockToken has no constructor arguments
        owner = address(this); // In Foundry, the deploying contract is the owner
        addr1 = address(0x1);
        addr2 = address(0x2);
    }

    /*
        @Topic : Basic
        @Score : 100
        @Title : Should mint and transfer tokens after timelock expired
        @Desc  : Test to ensure that only the owner can mint and user can transfer tokens after time lock expired.
    */
    function test_Should_Mint_And_Transfer_Tokens_With_Timelock() public {
        // Owner mints 1000 tokens to addr1
        myToken.mint(addr1, 1000);
        assertEq(myToken.balanceOf(addr1), 1000);

        // Addr2 fails to mint tokens because they are not the owner - expecting revert
        vm.prank(addr2);
        vm.expectRevert();
        myToken.mint(addr1, 1000);

        // Owner adds a 5 seconds lock to addr1
        uint lockTime = 5;
        myToken.addLock(addr1, lockTime);
        uint blockTimestamp = block.timestamp;
        assertTrue(myToken.lockUntil(addr1) > blockTimestamp);

        // Addr2 fails to add a lock because they are not the owner - expecting revert
        vm.prank(addr2);
        vm.expectRevert();
        myToken.addLock(addr1, lockTime);

        // Addr1 fails to transfer tokens because they are locked - expecting revert
        vm.prank(addr1);
        vm.expectRevert();
        myToken.transfer(addr2, 500);

        // Increase time by 5 seconds
        vm.warp(blockTimestamp + lockTime);

        // Addr1 transfers 500 tokens to addr2
        vm.prank(addr1);
        myToken.transfer(addr2, 500);
        assertEq(myToken.balanceOf(addr1), 500);
        assertEq(myToken.balanceOf(addr2), 500);
        vm.writeLine(
            FILE_NAME,
            "\test_Should_Mint_And_Transfer_Tokens_With_Timelock"
        );
    }


}
