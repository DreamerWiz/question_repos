# SocialCards question

### Introduction
The `socialCards` contract is a decentralized social application built on EVM that allows for the sale and approval of cards between users. The contract has various features including a pricing model, whitelist for presale contributors, transfers, and approvals, as well as event logging.

---

### Features

#### Access Control
- **Ownership Control**: Only the contract owner can modify the fee destination, set protocol fees, and set subject fees.
  
#### Fee Settings
- **Protocol Fee Destination**: Can be set by the owner.
- **Protocol Fee Percent**: Can be set by the owner, each trading should split fee to fee destination.
- **Subject Fee Percent**: Can be set by the owner, each trading should split fee to card subject.

#### Pricing
- **Pricing formula**: $|\sum_{newSupply=1}^{n} newSupply^2 - \sum_{supply=1}^{n} supply^2| * 1ether \div 16000$ 

- **Get Price**: Calculates the price using a mathematical model based on the existing supply and requested amount.
- **Buy Price After Fee**: Calculate buying price after fee based on existing cards.
- **Sell Price After Fee**: Calculate selling price after fee based on existing cards.

#### Cards Operations
- **Buy Cards**: Users can buy cards.
- **Sell Cards**: Users can sell cards.
- **Transfer Cards**: Users can transfer their cards to another account.
- **Approve Cards**: Users can approve another account to spend their cards.

#### Event Logging
- **Transfer Event**: Logs the transfer of cards.
- **Approval Event**: Logs the approval of spending cards.
- **Trade Event**: Logs buying or selling activity of cards.

#### Presale Operations
- **Set Presale Price**: Allows setting of the presale details.
- **Whitelist**: Allows for whitelisting users for presales.
- **Contributions**: Allows users to contribute to the presale of a subject.
- **Contribute to Presale**: Allows users to contribute to the presale.
- **Public Card**: Allows the user to finish their presale and public card that every user can buy and sell.
- **Claim Card**: Allows users to claim the contributed cards after presale.


---
