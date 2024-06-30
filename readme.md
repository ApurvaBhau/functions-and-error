# Functions and Errors - ETH + AVAX
A smart contract that implements the require(), assert() and revert() statements.

## Description

Written in Solidity, a programming language used to create smart contracts on the Ethereum blockchain, this program is a straightforward contract. The following are the functions of the contract:

(1) uses require() statement.

(2) uses assert() statement.

(3) uses revert() statement.

## Getting Started

### Functionalities

1. require(): Used to validate conditions such as input parameters and access control. If the condition is not met, the transaction is reverted with an optional error message.
**Example:** require(msg.value > 0, "Deposit amount must be greater than zero");

2. assert(): Used to check for conditions that should never occur (internal errors or invariants).If the condition is false, it uses up all the remaining gas and reverts the transaction.
**Example:** assert(balance >= 0);

3. revert(): Explicitly causes the transaction to fail and revert all changes made during the transaction. Can include a custom error message.
**Example:** revert("Only the owner can reset the balance");

### Executing program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., HelloWorld.sol). Copy and paste the code from contract.sol file into your file:

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to latest solidity version (or another compatible version), and then click on the "Compile" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the your contract from the dropdown menu, and then click on the "Deploy" button.

Once the contract is deployed, you can interact with it by calling the requireInstance, assertInstance and revertInstance function.

## Authors
Apurva bhau
## License

This project is licensed under the MIT License - see the LICENSE.md file for details
