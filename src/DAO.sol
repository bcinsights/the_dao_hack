// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DAO {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 balance = balances[msg.sender];
        if (balance <= 0) {
            revert("You have no deposited funds to withdraw");
        }
        (bool sent, ) = msg.sender.call{value: balance}("");
        balances[msg.sender] = 0;
        if (!sent) {
            revert("Ether withdrawal failed");
        }
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}