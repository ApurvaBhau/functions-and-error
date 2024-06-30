// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ErrorHandling {
    
    address public owner;
    uint256 public balance;
    
    constructor() {
        owner = msg.sender;
        balance = 0;
    }
    
    // Function to deposit ether into the contract
    function deposit() public payable {
        // Using require() to check for a valid deposit amount
        require(msg.value > 0, "Deposit amount must be greater than zero");
        
        balance += msg.value;
    }
    
    // Function to withdraw ether from the contract
    function withdraw(uint256 amount) public {
        // Using require() to ensure the caller is the owner
        require(msg.sender == owner, "Only the owner can withdraw funds");
        // Using require() to check sufficient balance
        require(balance >= amount, "Insufficient balance");
        
        balance -= amount;
        payable(owner).transfer(amount);
    }
    
    // Function to demonstrate the use of assert()
    function checkInvariant() public view {
        // Using assert() to check an invariant condition
        assert(balance >= 0);
    }
    
    // Function to demonstrate the use of revert() with custom error message
    function resetBalance() public {
        // Only the owner can reset the balance
        if (msg.sender != owner) {
            revert("Only the owner can reset the balance");
        }
        
        balance = 0;
    }
}
