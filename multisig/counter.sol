pragma solidity ^0.8.14;

// SPDX-License-Identifier: MIT

contract Counter {
    uint public count;

    function countValue() public view returns (uint) {
        return count;
    }
    
    function increment() external {
        count += 1;
    }
}

