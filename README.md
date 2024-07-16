# Role based Vesting smart Contract

# Imports
@openzeppelin/contracts/token/ERC20/ERC20.sol
Imported ERC20 tokens and used this tokens in the contract for vesting

This contract manages the distribution of tokens to beneficiaries according to the predefined vesting schedules.It ensures that tokens are gradually released to the beneficiaries based on the cliff and duration specified.

# Features
1.Role based Vesting : Different roles(User,Partner,Team) have different token allocation percentages and vesting schedules.

2.Vesting Management: Allows the owner to set up and manage vesting schedules for users,partners and team members.

3.Event Emissions : Emits events for important events like vesting starting,adding beneficiary and releasing tokens to the beneficiary.

4.Secure Ownership : Only the contract owner can start vesting and add beneficiaries.

# Deployment 

1.Compile the Contract:
  Use Remix or any solidity compiler to compile 'vestingTokens' contract.

2.Deploy the Contract:
  Deploy the contract on any testnet(Sepholia testnet)or Ethereum mainnet.

3.Initialize the contract :
  After deployment,initialize the contract with total tokens we want to vest

4.Start vesting:
  start the vesting process by calling 'startVesting' as owner

5.Add Beneficiaries:
  Add beneficiaries with their respective roles(User,Partner,Team) and token allocation before starting the vesting process.

6.Release Tokens:
  Beneficiaries can call the 'releaseTokens' function to claim their vested tokens according to schedule.

# Testing
We can test the functionality using Remix or a local development environment like Truffle or Hardhat. Make sure to:

  Deploy the contract with the total token supply.

  Add beneficiaries with different roles and allocations.

  Start the vesting process.

  Simulate the passage of time and release tokens for the beneficiaries.


