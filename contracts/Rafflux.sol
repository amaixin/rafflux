//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "hardhat/console.sol";
import "./RaffluxStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Rafflux is RaffluxStorage, IERC721Receiver {
  address public erc721contractAddr;
  IERC721 erc721contract = IERC721(erc721contractAddr);
  IERC1155 erc1155contract = IERC1155(erc721contractAddr);
  ERC721 token;

    enum assetType {
        ERC721,
        ERC1155
    }
    //launcher 
    constructor() {
        owner = msg.sender;
    }

   

    function _transferFromSeller(assetType _type, address _seller, uint256 _assetID) internal{
    if (_type == assetType.ERC721) {
      erc721contract.safeTransferFrom(_seller, address(this), _assetID);
    } else if (_type == assetType.ERC1155) { 
      erc1155contract.safeTransferFrom(_seller, address(this), _assetID, 1, "");
    }
  }



    function createRaffle(assetType _type, uint _id, address _contractAddr, uint _participateFee) public payable{
        require(msg.value == raffleSellersEntryFee, "insufficient funds");
        erc721contract = IERC721(_contractAddr);
        minRaffleParticipationFee = _participateFee;
        _transferFromSeller(_type, msg.sender, _id);
        idToRaffleItem[_id] = RaffleItem(_id, msg.sender, block.timestamp);
    }

    function onERC721Received( address operator, address from, uint256 tokenId, bytes calldata data ) public override returns (bytes4) {
            return this.onERC721Received.selector;
        }
        
    function transferBal( address payable _to, uint amt) public {
         _to.transfer(amt);
    }


    function getBal(address _add) public view returns (uint){
        return _add.balance;
    }


}