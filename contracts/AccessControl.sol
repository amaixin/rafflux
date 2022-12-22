//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "./RaffluxStorage.sol";

contract AccessControl is RaffluxStorage{

           //Approve Raffle Items
        function approveRaffleItems(uint _id) public {
          require(msg.sender == owner, "Must be owner");
          require(idToRaffleItemPending[_id].state == ProposalSate.Pending, "Item not pending");

          //get asset type
            assetType _type = idToRaffleItemPending[_id]._type;

          ProposalSate _state = ProposalSate.Approved;
          idToRaffleItem[_id] = RaffleItem(_id, msg.sender, block.timestamp, _state, _type);
          raffleItems.push(RaffleItem(_id, msg.sender, block.timestamp, _state, _type)); 

          //delete from mapping
          delete  idToRaffleItemPending[_id];

          //remove item from array
          for(uint i = _id; i < raffleItemsPending.length -1; i++){
            raffleItemsPending[i] = raffleItemsPending[i + 1];
          }
          raffleItemsPending.pop();
        }


        function _transferFromContract(assetType _type, address _seller, uint256 _assetID ) internal{
        //set respective contract addresses
        
        erc721contract = IERC721(address(this));
        erc1155contract = IERC1155(address(this));
        if (_type == assetType.ERC721) {
        erc721contract.safeTransferFrom(address(this), _seller, _assetID);
        } else if (_type == assetType.ERC1155) { 
        erc1155contract.safeTransferFrom(address(this), _seller, _assetID, 1, "");
        }
  }

           //Reject Raffle Items
        function rejectPendingRaffleItems(uint _id) public payable{
          require(msg.sender == owner, "Must be owner");
          require(idToRaffleItemPending[_id].state == ProposalSate.Pending, "Item not pending");

          //refund seller fee
          require(msg.value ==  raffleSellersEntryFee, "Must refund seller fee");

          //get owner address
          address _to = idToRaffleItemPending[_id].owner;
          assetType _type = idToRaffleItemPending[_id]._type;

          //transfer back seller item
        _transferFromContract(_type, _to, _id); 


          //delete from mapping
          delete  idToRaffleItemPending[_id];

          //remove item from array
          for(uint i = _id; i < raffleItemsPending.length -1; i++){
            raffleItemsPending[i] = raffleItemsPending[i + 1];
          }
          raffleItemsPending.pop();
        }





            function onERC721Received( address operator, address from, uint256 tokenId, bytes calldata data ) public pure returns (bytes4) {
            return this.onERC721Received.selector;
             
        }

    function onERC1155Received( address operator, address from, uint256 tokenId, uint256 value, bytes calldata data ) public pure returns (bytes4) {
            return this.onERC1155Received.selector;
             
        }
}