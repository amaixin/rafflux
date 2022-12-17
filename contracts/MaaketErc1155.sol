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

function createNft() public payable{
  require(msg.value == 0.02 ether, "insufficient fees");
   uint currentId = _tokenID.current();
    _mint(msg.sender, currentId, 5, "");
    // safeTransferFrom(msg.sender, address(this), currentId, 2, "");
}


  function onERC1155Received( address operator, address from, uint256 tokenId, uint256 value, bytes calldata data ) public pure returns (bytes4) {
            return this.onERC1155Received.selector;
             
        }
}