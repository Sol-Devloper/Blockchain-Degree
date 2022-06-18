//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

// This is a basic contract to deposit and withdraw moent from the contract, Part of teh online degree.

contract Money {
    uint256 money;

    function deposit(uint256 _money) public {
        money = _money;
    }

    function withdraw() public view returns (uint256) {
        return money * 2;
    }
}
