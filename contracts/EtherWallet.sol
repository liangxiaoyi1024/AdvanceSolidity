// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract EtherWallet {

    address payable public immutable owner;
    event Log(string funName, address from, uint256 value, bytes data);

    constructor(){
        owner = payable(msg.sender);

    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    function withdraw1() external {
        require(msg.sender == owner, "Not owner");
        payable(msg.sender).transfer(100); //transfer
    }

    function withdraw2() external {
        require(msg.sender == owner, "Not owner");
        bool success = payable(msg.sender).send(100); //send
        require(success, "Send failed");
    }

    function withdraw3() external {
        require(msg.sender == owner, "Not owner");
        (bool success, ) = msg.sender.call{value: address(this).balance}(""); // call
        require(success, "Call failed");
        
    }
 }