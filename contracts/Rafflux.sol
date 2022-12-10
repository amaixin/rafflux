//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "hardhat/console.sol";
import "./RaffluxStorage.sol";

contract Rafflux is RaffluxStorage {
  
  address public erc721contractAddr;
  IERC721 erc721contract = IERC721(erc721contractAddr);
  IERC1155 erc1155contract = IERC1155(erc721contractAddr);

    enum assetType {
        ERC721,
        ERC1155
    }
    //launcher 
    constructor() {
        owner = payable(msg.sender);
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
        erc721contractAddr = _contractAddr;
        minRaffleParticipationFee = _participateFee;
        _transferFromSeller(_type, msg.sender, _id);
    }

    function transferBal( address payable _to, uint amt) public {
         _to.transfer(amt);
    }


    function getBal(address _add) public view returns (uint){
        return _add.balance;
    }


}