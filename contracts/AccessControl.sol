//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "./RaffluxStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol"; 

contract AccessControl is RaffluxStorage {

           //Approve Raffle Items
        function approveRaffleItems(uint _id) public {
          require(msg.sender == owner, "Must be owner");
          require(idToRaffleItemPending[_id].state == ProposalSate.Pending, "Item not pending");

          //get asset type
            assetType _conType = idToRaffleItemPending[_id]._type;

          ProposalSate _state = ProposalSate.Approved;
          idToRaffleItem[_id] = RaffleItem(_id, msg.sender, block.timestamp, _state, _conType);
          raffleItems.push(RaffleItem(_id, msg.sender, block.timestamp, _state, _conType)); 

          //delete from mapping
          delete  idToRaffleItemPending[_id];

          //remove item from array
          for(uint i = _id; i < raffleItemsPending.length -1; i++){
            raffleItemsPending[i] = raffleItemsPending[i + 1];
          }
          raffleItemsPending.pop();
        }


 

        function refundNftItems(assetType _conType, address _seller, uint256 _id ) internal{
            if (_conType == assetType.ERC721) {
                 erc721contract.safeTransferFrom(address(this), _seller, _id);
            } else if (_conType == assetType.ERC1155) { 
                 erc1155contract.safeTransferFrom(address(this), _seller, _id, 1, ""); 
        }
        }


           //Reject Raffle Items
        function rejPenRafItems(uint _id) public payable{ 
          require(msg.sender == owner, "Must be owner");
          require(idToRaffleItemPending[_id].state == ProposalSate.Pending, "Item not pending");

          //refund seller fee
          require(msg.value == raffleSellersEntryFee, "Must refund seller fee");
          payable(idToRaffleItemPending[_id].owner).transfer(msg.value);

          address _to = idToRaffleItemPending[_id].owner;
          assetType _type = idToRaffleItemPending[_id]._type;

         //   transfer back seller item
          refundNftItems(_type, _to, _id); 

          //delete from mapping
          delete  idToRaffleItemPending[_id];

          // remove item from array
          for(uint i = _id; i < raffleItemsPending.length -1; i++){
            raffleItemsPending[i] = raffleItemsPending[i + 1];
          }
          raffleItemsPending.pop();
        }


}