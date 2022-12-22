// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";



contract Maaket is ERC721URIStorage {
    address owner;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _soldItems;
    using SafeMath for uint;
    

    uint256 listingPrice = 0.02 ether;
    

    constructor() payable ERC721("Maaket", "MTK"){

        owner = payable(msg.sender);
    }

    struct ItemData {
        uint256 id;
        address payable owner;
        address payable seller;
        uint256 price;
        bool listed;
    }


    modifier onlyOwner {
        require(msg.sender == owner, "Must be owner~");

        _;
    }


    mapping(uint256 => ItemData) listedItem;


    function updateListingPrice(uint256 _newPrice) public payable onlyOwner{
        listingPrice = _newPrice;
    
    }

    function getListingPrice() public view returns(uint256){
        return listingPrice;
    }

    function getLatestListedToken() public view returns (ItemData memory) {

        uint256 currentItem = _tokenIdCounter.current();
        return listedItem[currentItem];
    }


    function getListedToken (uint256 _id) public view returns(ItemData memory){
        return listedItem[_id];
    }

    function getCurrentTokenId () public view returns (uint256) {
        return _tokenIdCounter.current();
    }


    function createListedToken(uint256 id, uint256 price) private {
        listedItem[id] = ItemData(id, payable(address(this)), payable(msg.sender), price,  true);
        // _transfer(msg.sender, address(this), id);

    }

    function createNft(string memory tokenURI, uint256 price) public payable returns (uint256){
        require(msg.value == listingPrice, "Not enough ether to list" );
        require(price > 0, "Price must not be negative" );
        _tokenIdCounter.increment();
        uint256 currentId = _tokenIdCounter.current();

        _safeMint(msg.sender, currentId);
        _setTokenURI(currentId, tokenURI);

        createListedToken(currentId, price);

        return currentId;


    }


    function getAllNfts() public view returns (ItemData[] memory){
        uint currentCount = _tokenIdCounter.current();

        ItemData[] memory allNfts = new ItemData[](currentCount);

        uint currentIndex = 0;

        for(uint i = 0; i < currentCount; i++ ){
            uint currentId = i + 1;

            ItemData storage currentItem = listedItem[currentId];
            allNfts[currentIndex] = currentItem;
            currentIndex += 1;
        }

        return allNfts;
    }


    function getMyNfts() public view returns(ItemData[] memory ){
        uint totalitemCount = _tokenIdCounter.current();
        uint itemCount = 0;
        uint currentIndex = 0;


        for(uint i = 0; i < totalitemCount; i++){
            if(listedItem[i+1].owner == msg.sender || listedItem[i+1].seller == msg.sender){
                itemCount +=1;
            }
        }



        ItemData[] memory nfts = new ItemData[](itemCount);

        for(uint i = 0; i < totalitemCount; i++ ){
             if(listedItem[i+1].owner == msg.sender || listedItem[i+1].seller == msg.sender){
                uint currentId = i+1;
                ItemData storage currentItem = listedItem[currentId];
                nfts[currentIndex] = currentItem;
                currentIndex +=1 ;
            }
        }

        return nfts;
    }


    function executeNFTSale (uint256 _id) public payable{
        uint price = listedItem[_id].price;
        require(msg.value == price, "Insufficient funds");

        address seller = listedItem[_id].seller;
        listedItem[_id].listed = true;
        listedItem[_id].seller = payable(msg.sender);
        _soldItems.increment();

        _transfer(address(this), msg.sender, _id);
        approve(address(this), _id);

        //transfer listing fee to contract who acts as owner
        payable(owner).transfer(listingPrice);
        //transfer NFT sale price of NFT to the item seller
        payable(seller).transfer(msg.value);

    }



    // The following functions are overrides required by Solidity.


}