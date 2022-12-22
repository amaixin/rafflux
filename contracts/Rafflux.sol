//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "./AccessControl.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
// import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

contract Rafflux is AccessControl {
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
        ProposalSate _state = ProposalSate.Pending;
          
        minRaffleParticipationFee = _participateFee;
        _transferFromSeller(_type, _contractAddr, msg.sender, _id);
        idToRaffleItemPending[_id] = RaffleItem(_id, msg.sender, block.timestamp, _state, _type);
        raffleItemsPending.push(RaffleItem(_id, msg.sender, block.timestamp, _state, _type)); 
    }


        //Get Pending Raffle Item
        function returnPendingRaffleItem(uint _id) public view returns (RaffleItem memory){
          return idToRaffleItemPending[_id];
        }
        
           //Get All Pending Raffle Items
           function returnAllPendingRaffleItems() public view returns (RaffleItem[] memory){
            return raffleItemsPending;
           }

        //Get Approved Raffle Item
        function returnRaffleItem(uint _id) public view returns (RaffleItem memory){
          return idToRaffleItem[_id];
        }
        
           //Get All Approved Raffle Items
           function returnAllRaffleItems() public view returns (RaffleItem[] memory){
            return raffleItems;
           }
        

    function transferBal( address payable _to, uint amt) public {
         _to.transfer(amt);
    }


    function getBal(address _add) public view returns (uint){
        return _add.balance;
    }





}