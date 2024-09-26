// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Wallet {
    
    address public owner;
    uint256 public balance;

    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed receiver, uint256 amount);
    event BalanceReset(address indexed owner);

    constructor() {
        owner = msg.sender;
        balance = 0;
    }
    
    // Function to deposit ether into the contract
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balance += msg.value;
        emit Deposited(msg.sender, msg.value);
    }
    
    // Function to withdraw ether from the contract
    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can withdraw funds");
        require(balance >= amount, "Insufficient balance");

        balance -= amount;
        payable(owner).transfer(amount);
        emit Withdrawn(owner, amount);
    }

    // Function to check the contract's balance
    function getBalance() public view returns (uint256) {
        return balance;
    }

    // Function to check if the balance is non-negative
    function checkInvariant() public view {
        assert(balance >= 0);
    }
    
    // Function to reset the balance
    function resetBalance() public {
        require(msg.sender == owner, "Only the owner can reset the balance");
        balance = 0;
        emit BalanceReset(owner);
    }

    // Function to transfer ether to another address
    function transfer(address payable recipient, uint256 amount) public {
        require(msg.sender == owner, "Only the owner can transfer funds");
        require(balance >= amount, "Insufficient balance for transfer");

        balance -= amount;
        recipient.transfer(amount);
    }
}

