// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NewCoin is ERC20 {
    uint public timeLock = block.timestamp + 10 * 365 days;
    uint256 public INITIAL_SUPPLY;
    address public investor;

    constructor(address _investor) ERC20("NewCoin", "0x0") {
        INITIAL_SUPPLY = 5000000 * (10 ** uint256(decimals()));
        investor = _investor;
        _mint(investor, 1000000 * (10 ** uint256(decimals())));
        emit Transfer(
            address(0),
            investor,
            1000000 * (10 ** uint256(decimals()))
        );
    }

    // Prevent the investor from transferring tokens until the timelock has passed
    modifier timeLocker() {
        if (msg.sender == investor) {
            require(block.timestamp > timeLock);
            _;
        }
    }

    function transfer(
        address _to,
        uint256 _value
    ) public override timeLocker returns (bool) {
        return super.transfer(_to, _value);
    }
}
