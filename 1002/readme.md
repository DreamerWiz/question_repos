### NFT problem:

We need such an NFT design which has the following requirements.

I. When a new token is minted, the share of the new token will be a random number generated in the function, the number should be in the range 50 to 100. Do not set the share with a parameter.

II. NFT has a capacity limit, which can be set by a centralized function. The total number of NFTs should never exceed the capacity.

III. NFT owners can enjoy the passive ETH incomes based on the users’ shares from the dev team’s allocations. Once upon there are money transferred into the contract via function allocate(), all the nft owner can split the money equally based on the rate of their total share of token holdings to the all nft shares.

For example,

> Alice, Bob and Carl each get an NFT with share 50, 60, 70. And then the dev team allocate 180 ETHs into the contract by calling function allocate(). Because their share rates are 50/180, 60/180, 70/180. So they can get 50 ETH, 60 ETH, 70 ETH from the contract.
> 

The contract has inherited from the base ERC721 design, and here is the interface that the contract should implement:

```jsx
abstract contract baseContract is ERC721{
	constructor(address owner, uint capacity){}   // initialize owner and capacity
	function owner() external view returns(address); // return address of the owner
	function setCapacity(uint cap) external; // function for setting capacity.
	function capacity() external view returns(uint); // return the capacity.
	function mint(address account, uint tokenId) external; // function for mingting tokens.
    function tokenShare(uint tokenId) external view returns(uint); // return the share of the token.
	function earned() external view returns(uint); // return the amount of incomes that the message sender has earned.
	function claimed() external view returns(uint); // return the amount of calimed incomes of the message sender.
	function claim() external; // function for claiming rewards.
	function allocate() external payable; // function for allocating rewards.
}
```

Please make your contract as robust as possible, considering cover some unusual inputs and security risks. The final score will be influenced by these details.

Please don't change the contract name nor the constuctor, you can choose not to explicitly implement the interface. But the functions must exist in your contract, otherwise the test scripts can get errors and the test cannot pass.