# The Dutch Auction Smart Contract

This smart contract implements a Dutch auction mechanism for ERC20 tokens. In this auction, the item's price starts high and gradually decreases over time until it reaches a set lower limit or is purchased. Users can bid on the tokens during the live auction, and the highest bidder can claim the tokens after the auction ends. Auction owners have the ability to create, cancel, and end auctions, as well as claim profits. The contract also charges a 10% fee on the collected funds, which is sent to a predefined protocol address. Various checks and validations are in place to ensure proper auction setup, state transitions, and fund transfers.

### Please follow the inherited contract below:
```C#
abstract contract auctionBase {
    enum AuctionState {
        None,
        SETTELED,
        CANCELED,
        ENDED
    }

    struct Auction {
        address owner;
        IERC20 token;
        AuctionState state;
        uint256 startPrice;
        uint256 endPrice;
        uint256 startTime;
        uint256 endTime;
        uint256 depositedTokens;
        uint256 collectedFunds;
        uint256 lastPrice;
    }

    function getAuctionInfo(uint auctionId) public virtual view returns (Auction memory);

    function isAuctionLive(uint auctionId) public virtual view returns (bool);

    function getCurrentPrice(uint256 auctionId) public virtual view returns (uint256);

    function createAuction(
        address _token,
        uint256 _startPrice,
        uint256 _endPrice,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _tokenAmount
    ) public virtual;

    function cancelAuction(uint256 auctionId) public virtual;


    function bid(uint256 auctionId) public virtual payable;

    function claimTokens(uint256 auctionId) public virtual;

    function endAuctionAndClaimProfit(uint256 auctionId) public virtual;
}
```

#### Functions & Requirements

1. **Auction State Management**: Enum `AuctionState` to keep track of the auction's state.

2. **Auction Details**: Struct `Auction` containing details like owner, token, state, start and end prices, start and end times, and other relevant data. `AuctionId` should start with `1`.

3. **Contract Initialization**: A constructor that initializes the `protocolAddress` and contract `owner`.

4. **Auction Management**
   - `createAuction`: Creates an auction and validates the input like start and end times, start and end prices, token amount, and token address. Transfers tokens from the creator to the contract.
   - `cancelAuction`: Allows only the auction owner to cancel the auction under certain conditions. Transfers the tokens back to the owner.
   - `endAuctionAndClaimProfit`: Ends the auction and calculates profits and fees. Allows only the auction owner to call it.

5. **Bidding**
   - `bid`: Allows participants to bid for tokens. Validates auction state and whether the auction is live.
  
6. **Claiming Tokens**
   - `claimTokens`: Allows the winner to claim tokens once the auction has ended. Validates the state and that the auction is not live.
  
7. **Getters**
   - `getAuctionInfo`: Returns all auction details for a given auction ID.
   - `isAuctionLive`: Checks if an auction is live based on its start and end times.
   - `getCurrentPrice`: Calculates the current price of the auction based on time elapsed.

8. **Events**: Events to log important contract activities, such as creating, canceling, and bidding in an auction.


#### Conditions & Constraints

- The auction owner can only cancel an auction if it has not started and only the auction owner can end it.
- Bidding is only possible when the auction state is "Settled" and the auction is live.
- Tokens can only be claimed once the auction is over and if the user has made a bid.

#### Fee Management

- A 10% fee is charged on the collected funds and sent to a protocol address.
  
** This contract employs a Dutch auction mechanism where the price of the item (in this case, tokens) starts high and decreases over time until it reaches a predefined end price or the item is sold.