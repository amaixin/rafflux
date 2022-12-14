//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract RaffluxStorage{
  //address placeholders for erc1155 and erc721
  // address public erc721contractAddr;
  // address public erc1155contractAddr;
  IERC721 erc721contract;
  IERC1155 erc1155contract;


  //enum asset types
    enum assetType {
        ERC721,
        ERC1155
    }
  
       //Libs
    using Counters for Counters.Counter;
    Counters.Counter internal raffleIDsCounter;
    Counters.Counter internal raffleMembersParticipants;
    Counters.Counter internal raffleSellersParticipants;


        //Global Vars
    address owner;
    uint internal minRaffleParticipationFee;
    uint internal raffleSellersEntryFee = 0.02 ether;
    address[] internal vipUsers;
    uint internal housePointsSellers = 300;
    uint internal housePointsPartpants = 500;



    
    //Raffle Proposal State 
    enum ProposalSate {
        Pending,
        Approved,
        Rejected
    }

    //Raffle Item
    struct RaffleItem {
        uint id;
        address owner;
        uint date;
        ProposalSate state;
        assetType _type;
       
    }

      //Raffle Sellers
    struct AssetSeller {
        address sellerAddress;
        uint housePoints;
        uint id;
    }
    
      //Raffle Participants
    struct RaffleParticipants {
        address participantAddress;
         uint housePoints;
        uint _id;
    }


     mapping(uint => RaffleItem) internal idToRaffleItem;
     mapping(uint => RaffleItem) internal idToRaffleItemPending;

     //Raffle Items
     RaffleItem[] raffleItems;
     RaffleItem[] raffleItemsPending;


}
