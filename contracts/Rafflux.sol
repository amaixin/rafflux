//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "hardhat/console.sol";
import "./RaffluxStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
// import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

contract Rafflux is RaffluxStorage {

  //address placeholders for erc1155 and erc721
  address public erc721contractAddr;
  address public erc1155contractAddr;
  IERC721 erc721contract ;
  IERC1155 erc1155contract;

  //enum asset types
    enum assetType {
        ERC721,
        ERC1155
    }

    constructor() {
        owner = msg.sender;
    }

   

    function _transferFromSeller(assetType _type, address _contractType, address _seller, uint256 _assetID ) internal{
        //set respective contract addresses
        erc721contract = IERC721(_contractType);
        erc1155contract = IERC1155(_contractType);
    if (_type == assetType.ERC721) {
      erc721contract.safeTransferFrom(_seller, address(this), _assetID);
    } else if (_type == assetType.ERC1155) { 
      erc1155contract.safeTransferFrom(_seller, address(this), _assetID, 1, "");
    }
  }



    function createRaffle(assetType _type, uint _id, address _contractAddr, uint _participateFee) public payable{
        require(msg.value == raffleSellersEntryFee, "insufficient funds");
        minRaffleParticipationFee = _participateFee;
        _transferFromSeller(_type, _contractAddr, msg.sender, _id);
        idToRaffleItem[_id] = RaffleItem(_id, msg.sender, block.timestamp);
    }

    function onERC721Received( address operator, address from, uint256 tokenId, bytes calldata data ) public pure returns (bytes4) {
            return this.onERC721Received.selector;
             
        }

    function onERC1155Received( address operator, address from, uint256 tokenId, uint256 value, bytes calldata data ) public pure returns (bytes4) {
            return this.onERC1155Received.selector;
             
        }


        //Get Raffle Items
        function returnRaffleItems(uint _id) public view returns (RaffleItem memory){
          return idToRaffleItem[_id];
        }
        
    function transferBal( address payable _to, uint amt) public {
         _to.transfer(amt);
    }


    function getBal(address _add) public view returns (uint){
        return _add.balance;
    }





}