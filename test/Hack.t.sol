// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/DAO.sol";
import "../src/Attacker.sol";

contract TestSuite is Test {
    DAO dao;
    Attacker attacker;

    address alice = address(111);
    address bob = address(222);
    address hacker = address(333);

    function setUp() public {
        // Deploy contracts
        dao = new DAO();
        attacker = new Attacker(address(dao));

        // Fund addresses
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
        vm.deal(hacker, 10 ether);
    }

    function testSuccessfulReentrancyAttack() public {
        vm.startPrank(alice);
        dao.deposit{value: 1 ether}();
        vm.stopPrank();

        vm.startPrank(bob);
        dao.deposit{value: 1 ether}();
        vm.stopPrank();

        assertEq(dao.getBalance(), 2 ether);

        vm.startPrank(hacker);
        // Attack with the right amount
        attacker.attack{value: 1 ether}();
        vm.stopPrank();

        assertLt(dao.getBalance(), 1 ether);
        assertGt(attacker.getBalance(), 2 ether);

        vm.startPrank(hacker);
        // Attack with the right amount
        attacker.attack{value: 1 ether}();
        vm.stopPrank();

        assertGt(attacker.getBalance(), 3 ether);
    }
}
