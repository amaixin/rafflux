//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;


import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MaaketErc1155 is ERC1155 {
address private owner;
using Counters for Counters.Counter;

Counters.Counter private _tokenID;

constructor () ERC1155(""){
    owner = msg.sender;
    
}

function createNft() public {
  uint currentId = _tokenID.current();
    _mint(msg.sender, currentId, 4, "");
}
}