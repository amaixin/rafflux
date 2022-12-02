//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Rafflux is ERC721{
    //Libs
    using Counters for Counters.Counter;
    Counters.Counter raffleIDsCounter;
    Counters.Counter raffleMembersParticipants;
    Counters.Counter raffleSellersParticipants;


        //Global Vars
    address owner;
    uint minRaffleParticipationFee;
    uint raffleSellersEntryFee = 0.03 ether;
    address[] vipUsers;
    uint housePointsSellers = 300;
    uint housePointsPartpants = 500;

    //Raffle Proposal State 
    enum ProposalSate {
        Applied,
        Waiting,
        Approved,
        Rejected
    }

    //Raffle Item
    struct RaffleItem {
        uint id;
        address owner;
        string uri;
        string name;

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
        uint id;
    }



    //launcher
    constructor ()  ERC721("Rafflux", "RFX"){
        owner = msg.sender;
    }


}