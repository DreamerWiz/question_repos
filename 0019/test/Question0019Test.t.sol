// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import "../contracts/Question0019Solution.sol";

contract Question0019Test is Test {
    using ECDSA for bytes32;
    Question0019Solution private multiSigWallet;
    address private deployerAddress;
    address private attackerAddress;
    address private aliceAddress;
    uint256 private deployerPk;
    uint256 private attackerPk;
    uint256 private alicePk;
    uint256 val_1 = 1 ether;
    uint256 nonce_1 = 0x1;
    uint256 nonce_2 = 0x2;
    string constant FILE_NAME = "test/Question0019Test.t.sol.passed";

    function setUp() public {
        // Setup addresses for deployer, attacker, and Alice
        deployerPk = 0xa11ce;
        attackerPk = 0xa12ce;
        alicePk = 0xa13ce;
        deployerAddress = vm.addr(deployerPk);
        attackerAddress = vm.addr(attackerPk);
        aliceAddress = vm.addr(alicePk);
        // Deploy the Question0019Solution contract with deployer and Alice as signers
        multiSigWallet = new Question0019Solution([deployerAddress, aliceAddress]);
        vm.deal(address(multiSigWallet), 10 ether);
    }

    function test_Attacker_Should_Not_Transfer_With_Used_Signature() public {
        // Prepare transaction hash and signatures
        bytes32 digest = keccak256(abi.encodePacked(address(multiSigWallet), aliceAddress, val_1, nonce_1)).toEthSignedMessageHash();
        bytes32 digest2 = keccak256(abi.encodePacked(address(multiSigWallet), aliceAddress, val_1, nonce_2)).toEthSignedMessageHash();
        (uint8 v_1, bytes32 r_1, bytes32 s_1) = vm.sign(deployerPk, digest);
        (uint8 v_2, bytes32 r_2, bytes32 s_2) = vm.sign(alicePk, digest);
        (uint8 v_3, bytes32 r_3, bytes32 s_3) = vm.sign(deployerPk, digest2);
        (uint8 v_4, bytes32 r_4, bytes32 s_4) = vm.sign(alicePk, digest2);

        bytes[2] memory sigPair1;
        sigPair1[0] = abi.encodePacked(r_1, s_1, v_1);
        sigPair1[1] = abi.encodePacked(r_2, s_2, v_2);
        bytes[2] memory sigPair2;
        sigPair2[0] = abi.encodePacked(r_3, s_3, v_3);
        sigPair2[1] = abi.encodePacked(r_4, s_4, v_4);

        // Execute the transfer from the deployer
        vm.startPrank(deployerAddress);
        multiSigWallet.transfer(aliceAddress, 1 ether, nonce_1, sigPair1);
        multiSigWallet.transfer(aliceAddress, 1 ether, nonce_2, sigPair2);
        vm.stopPrank();

        // Attempt transfer from the attacker
        vm.startPrank(attackerAddress);
        // Attempt transfer with a used signature
        vm.expectRevert();
        multiSigWallet.transfer(aliceAddress, 1 ether, nonce_1, sigPair1);
        vm.stopPrank();
        // Log the test as passed
        vm.writeLine(FILE_NAME, "test_Attacker_Should_Not_Transfer_With_Used_Signature");
    }
}
