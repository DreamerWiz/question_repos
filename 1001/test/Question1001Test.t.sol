// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/StdStorage.sol";

import {Question1001Solution} from "../contracts/Question1001Solution.sol";
import {Question1001Attacker1, Question1001Attacker2, Question1001Attacker3} from "../contracts/Question1001Ext.sol";

contract Question1001Test is Test {
    using stdStorage for StdStorage;

    string constant FILE_NAME = "test/Question1001Test.t.sol.passed";

    Question1001Solution newToken;
    Question1001Attacker1 attacker1;
    Question1001Attacker2 attacker2;
    Question1001Attacker3 attacker3;
    address owner = address(1);
    address user1 = address(2);
    address user2 = address(3);

    function setUp() public {
        newToken = new Question1001Solution("My Token", "MTK", 1, owner);
        attacker1 = new Question1001Attacker1(address(newToken));
        attacker2 = new Question1001Attacker2(address(newToken));
        attacker3 = new Question1001Attacker3(address(newToken));
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Constructor should set the right owner and token price.
        @Desc : The owner and token price of the contract should equal to the parameters set in the constructor.
     */
    function test_Constructor_should_set_the_right_owner_and_token_price()
        public
    {
        assertEq(newToken.owner(), owner);
        assertEq(newToken.tokenPrice(), 1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Constructor_should_set_the_right_owner_and_token_price"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should mint tokens to the owner.
        @Desc : The owner can mint tokens for themselves via function mint().
     */
    function test_Should_mint_tokens_to_the_owner() public {
        vm.prank(owner);
        newToken.mint(owner, 100 ether);
        assertEq(newToken.balanceOf(owner), 100 ether);
        vm.writeLine(FILE_NAME, "\ntest_Should_mint_tokens_to_the_owner");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should only owner add new lock.
        @Desc : Only owner can add the lock, normal users should not have the privilege.
     */
    function test_Should_only_owner_add_new_lock() public {
        vm.prank(user1);
        vm.expectRevert();
        newToken.addLockedMint(user2, 100 ether, 100);
        vm.writeLine(FILE_NAME, "\ntest_Should_only_owner_add_new_lock");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should add lock and claim successfully.
        @Desc : Owner can add lock and after a certian number of blocks he can unlock correct amount according to the introduction.
     */
    function test_Should_add_lock_and_claim_successfully() public {
        vm.prank(owner);
        newToken.addLockedMint(user2, 100 ether, 100);
        vm.roll(block.number + 100);
        vm.prank(user2);
        newToken.claimUnlockedToken();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_add_lock_and_claim_successfully"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should claim linearly unlock tokens correctly.
        @Desc : The unlock speed should be equal to what is required.
     */
    function test_Should_claim_linearly_unlock_tokens_correctly() public {
        vm.prank(owner);
        newToken.addLockedMint(user2, 100 ether, 100);

        uint unlockPerBlock = (100 ether) / (100 - block.number);
        vm.roll(block.number + 5);
        vm.prank(user2);
        newToken.claimUnlockedToken();
        assertEq(newToken.balanceOf(user2), 5 * unlockPerBlock);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_claim_linearly_unlock_tokens_correctly"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should allow public minting with ETH.
        @Desc : Users can get the token by paying ETH via function `publicMint()`.
     */
    function test_Should_allow_public_minting_with_ETH() public {
        vm.deal(user1, 100 ether);
        vm.prank(user1);
        newToken.publicMint{value: 1 ether}();
        assertEq(newToken.balanceOf(user1), 1 ether);
        vm.writeLine(FILE_NAME, "\ntest_Should_allow_public_minting_with_ETH");
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should allow an address to mint up to 2 ETH.
        @Desc : The user can mint up to 2 ETH.
     */
    function test_Should_allow_an_address_to_mint_up_to_2_ETH() public {
        vm.deal(user1, 100 ether);
        vm.prank(user1);
        newToken.publicMint{value: 2 ether}();
        assertEq(newToken.balanceOf(user1), 2 ether);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_allow_an_address_to_mint_up_to_2_ETH"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should refund excess ETH if per address mint limit reached.
        @Desc : If the user mints up to 2 ETH and still has the extra part, the excess should be refunded to ensure no more than 2 ETH.
     */
    function test_Should_refund_excess_ETH_if_per_address_mint_limit_reached()
        public
    {
        vm.deal(user1, 100 ether);
        vm.prank(user1);
        newToken.publicMint{value: 2.1 ether}();
        assertEq(newToken.balanceOf(user1), 2 ether);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_refund_excess_ETH_if_per_address_mint_limit_reached"
        );
    }

    /*
        @Topic : Basic
        @Score : 5
        @Title : Should refund excess ETH if 5000 ETH mint limit reached.
        @Desc : If the total 5000 ETH is reached, no more tokens can be minted.
     */
    function test_Should_refund_excess_ETH_if_5000_ETH_mint_limit_reached()
        public
    {
        stdstore
            .target(address(newToken))
            .sig(bytes4(keccak256("totalEthMinted()")))
            .checked_write(4999 ether);
        hoax(user1, 2 ether);
        newToken.publicMint{value: 2 ether}();
        assertEq(newToken.balanceOf(user1), 1 ether);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_refund_excess_ETH_if_5000_ETH_mint_limit_reached"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Should fail deployment when owner is zero or token price is zero.
        @Desc : The deployment should fail if the parameters are zero.
     */
    function test_Should_fail_deployment_when_owner_is_zero_or_token_price_is_zero()
        public
    {
        vm.expectRevert();
        new Question1001Solution("My Token", "MTK", 0, owner);
        vm.expectRevert();
        new Question1001Solution("My Token", "MTK", 1, address(0));
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_fail_deployment_when_owner_is_zero_or_token_price_is_zero"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Cannot mint to zero address.
        @Desc : The function mint() should revert if the mint target is zero address.
     */
    function test_Cannot_mint_to_zero_address() public {
        vm.expectRevert();
        vm.prank(owner);
        newToken.mint(address(0), 1);
        vm.writeLine(FILE_NAME, "\ntest_Cannot_mint_to_zero_address");
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Should fail to add lock to zero address.
        @Desc : The function addLockedMint() should revert if the mint target is zero address.
     */
    function test_Should_fail_to_add_lock_to_zero_address() public {
        vm.expectRevert();
        vm.prank(owner);
        newToken.addLockedMint(address(0), 100 ether, block.number + 20);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_fail_to_add_lock_to_zero_address"
        );
    }

    /*
        @Topic : Detail
        @Score : 5
        @Title : Should fail to add lock with old block number.
        @Desc : The function addLockedMint() should revert if the lockEnd number is before current.
     */
    function test_Should_fail_to_add_lock_with_old_block_number() public {
        vm.expectRevert();
        vm.prank(owner);
        newToken.addLockedMint(user1, 100 ether, block.number - 1);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_fail_to_add_lock_with_old_block_number"
        );
    }

    /*
    @Topic : Detail
    @Score : 5
    @Title : Should add lock and claim successfully.
    @Desc : Tokens should be locked and then claimed successfully after the locking period.
    */
    function test_Should_add_lock_and_claim_successfully_v2() public {
        vm.prank(owner);
        newToken.addLockedMint(user2, 6500, block.number + 100);
        vm.prank(owner);
        vm.roll(block.number + 1);
        newToken.addLockedMint(user2, 6400, block.number + 100);
        vm.roll(block.number + 101);
        vm.prank(user2);
        newToken.claimUnlockedToken();
        assertEq(newToken.balanceOf(user2), 12900);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_add_lock_and_claim_successfully_v2"
        );
    }

    /*
    @Topic : Detail
    @Score : 5
    @Title : Should claim linearly unlock tokens correctly with lock recalculating.
    @Desc : Tokens should be unlocked linearly with lock recalculations and claimed correctly.
    */
    function test_Should_claim_linearly_unlock_tokens_correctly_with_lock_recalculating_v2()
        public
    {
        vm.prank(owner);
        newToken.addLockedMint(user2, 6500, block.number + 100);
        uint unlockPerBlock = 6500 / (block.number + 100 - block.number);
        vm.prank(owner);
        vm.roll(block.number + 1);
        newToken.addLockedMint(user2, 6400, block.number + 99);
        uint unlockPerBlock2 = (12900 - unlockPerBlock) /
            (block.number + 99 - block.number);
        vm.roll(block.number + 50);
        vm.prank(user2);
        newToken.claimUnlockedToken();
        uint expectedBalance = unlockPerBlock + unlockPerBlock2 * 50; // Passed 50 blocks after 2nd lock
        console.logUint(expectedBalance);
        assertEq(newToken.balanceOf(user2), expectedBalance);
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_claim_linearly_unlock_tokens_correctly_with_lock_recalculating_v2"
        );
    }

    /*
    @Topic : Detail
    @Score : 5
    @Title : Should claim linearly unlock tokens correctly after unlockedBlocks.
    @Desc : Tokens should be claimed correctly after all blocks are unlocked.
    */
    function test_Should_claim_linearly_unlock_tokens_correctly_after_unlockedBlocks_v2()
        public
    {
        vm.prank(owner);
        newToken.addLockedMint(user2, 6500, block.number + 100);
        vm.prank(owner);
        newToken.addLockedMint(user2, 6400, block.number + 100);
        vm.roll(block.number + 101);
        vm.prank(user2);
        newToken.claimUnlockedToken();
        assertEq(newToken.balanceOf(user2), 12900); // Full 6500 + 6400
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_claim_linearly_unlock_tokens_correctly_after_unlockedBlocks_v2"
        );
    }

    /*
    @Topic : Security
    @Score : 5
    @Title : Should use .call to transfer ETH rather than .transfer to support proxy contracts.
    @Desc : The contract should use .call to transfer ETH to support potential proxy contracts and not revert.
    */
    function test_Should_use_call_to_transfer_ETH_rather_than_transfer()
        public
    {
        vm.deal(address(attacker1), 1000 ether);
        attacker1.attack{value: 1000 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_use_call_to_transfer_ETH_rather_than_transfer"
        );
    }

    /*
        @Topic : Security
        @Score : 5
        @Title : Should check the result of .call function to revert if failed.
        @Desc : The contract should check the result of .call function and revert if it failed.
    */
    function test_Should_check_the_result_of_call_function_to_revert_if_failed()
        public
    {
        vm.deal(address(attacker2), 1000 ether);
        vm.expectRevert();
        attacker2.attack{value: 1000 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_check_the_result_of_call_function_to_revert_if_failed"
        );
    }

    /*
        @Topic : Security
        @Score : 5
        @Title : Should prohibit reentrancy issue in publicMint().
        @Desc : The publicMint() function should prohibit reentrancy attacks and revert.
    */
    function test_Should_prohibit_reentrancy_issue_in_publicMint() public {
        vm.deal(address(attacker3), 1000 ether);
        vm.expectRevert();
        attacker3.attack{value: 1000 ether}();
        vm.writeLine(
            FILE_NAME,
            "\ntest_Should_prohibit_reentrancy_issue_in_publicMint"
        );
    }
}
