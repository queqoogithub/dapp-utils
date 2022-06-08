// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

// NOTE: Deploy this contract first
contract B { // >>>>>>> IMPLEMENT CONTRACT <<<<<<<
    // NOTE: storage layout must be the same as contract A => เรียก var พวกนี้ว่า state variable
    //uint public what; // ถ้าเราเพิ่ม state var เข้าไปจะทำให้ contract A เพี้ยน (ตรงนี้ต้องไปดูว่า state var ของ contract B มัน map กับ contract A ได้ยังไง ?)
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable {
        num = _num; // ถ้าเราอัพเดท contract นี้ โดยเปลี่ยน num = _num + 1 (ช่วยให้เราไม่ต้องแก้ไข code ใน contract A แต่ได้ผลลัพธ์เปลี่ยนไป => concept ของ contract update)  
        sender = msg.sender;
        value = msg.value;
    }
}

contract A { // >>>>>>> PROXY CONTRACT <<<<<<<
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}
