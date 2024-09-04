# Smart Contract for a Yearly Renewable Insurance Pool

The provided smart contract, written in Solidity, implements a blockchain-based insurance scheme where insurance pools are created with a one-year validity. The contract allows for the establishment of insurance pools, calculation and payment of premiums, and claims processing. It also provides a mechanism for insurers to deposit funds into the pool and claim premiums post-expiration of the pool term.

## Functional Specifications
1. **Adding Insurance Pools**:
   - The `addOneYearInsurancePool` function allows the contract owner to create a new insurance pool, initializing its parameters like coverage, funding, and timestamp of creation.
   
2. **Calculating Premium**:
   - The `calculatePremium` function computes the premium amount for a specified coverage amount and insurance pool, based on a formula that considers the current funding and coverage of the pool.
   
3. **Insuring**:
    - The `insure` function allows users to buy insurance by specifying a coverage amount and the insurance pool, and sending the calculated premium as payment.
    - The `insure` function checks that the requested coverage does not exceed the deposited funds in the pool.
   
4. **Depositing Funds**:
   - Insurers can deposit funds to an insurance pool using the `depositFunds` function, which updates the insurer's and the insurance pool's records.
   - Each address can only deposit funds one time.
   
5. **Claiming Premium**:
   - Post the one-year term, insurers can claim their share of the unclaimed premiums using the `claimPremium` function which calculates and transfers the eligible amount.
   
6. **Approving and Claiming Coverage**:
   - The contract owner can approve claims using the `approveClaimCoverage` function, after which policyholders can claim their coverage amount using the `claimCoverage` function.

7. **Ownership Restriction**:
   - Some actions like adding insurance pools and approving claims are restricted to the contract owner through the `onlyOwner` modifier.


## Calculating Explanation

- **Calculating Capital Ratio Value**:
   - The capital ratio is calculated using the formula:
     $capitalRatioValue=coverageInput(currentFunding-currentCoverage*0.995)/[(currentFunding - newCoverage*0.995)]$
   - This ratio represents the current funds of the pool relative to the new total coverage (existing coverage plus the new coverage amount) adjusted by a factor of 0.995. The adjustment ensures that the pool maintains a small buffer to cover 99.5% of the total coverage.

- **Calculating Premium**:
   - Finally, the premium amount (price to buy insurance policy) is calculated by multiplying the `coverageInput` (the amount of coverage the policyholder wishes to buy) with the `capitalRatio`, and then added by baseRate=1% for `coverageInput`:  $Premium = (coverageInput * baseRate + capitalRatioValue) / 100$
   
- **Calculating Eligible Premium**:
   - The eligible premium share for an insurer is calculated using the formula:
     $eligiblePremium = premiumShareFee * insurerDepositFunds / poolCurrentFunds$
   - Here, the `premiumShareFee` is half of the total premium collected by the pool ($premiumCollected / 2$). The formula represents the proportion of the eligible premium share based on the funds the insurer has in the pool relative to the total funds in the pool.

- **Calculating Time Share**:
   - The share of premium based on time elapsed since the insurer's last deposit is calculated using the formula:
     $share =eligiblePremium*timeElapsed/365 days$
   - `timeElapsed` is the difference between the `poolExpiredDate` (which is the creation timestamp of the pool plus 365 days) and the insurer's last deposit timestamp. The formula calculates the share of premium the insurer is eligible to claim based on the time they have participated in the pool.

- **Calculating Surplus Funds**:
   - The surplus funds for an insurer is calculated using the formula:
     $surFunds = insurerDepositFunds*(poolCurrentFunds-poolCoverageApproved)/poolCurrentFunds$
   - This formula calculates the remaining funds for an insurer based on the total approved coverage claims from the pool. It represents the proportion of surplus funds the insurer has in the pool relative to the total funds in the pool after approved coverage claims have been deducted.

- **Total Claimable Amount**:
   - Finally, the total claimable amount by an insurer is the sum of the `share` and `surFunds`.
   - This represents the total amount an insurer can claim, which includes their share of the premium and their share of the surplus funds after all approved coverage claims have been deducted from the pool.