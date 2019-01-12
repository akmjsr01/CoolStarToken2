pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract StarNotary is ERC721 {

    struct Star {
        string name;
    }

    function name() public pure returns (string){
        return "CoolStarToken";
    }
    function symbol() public pure returns(string) {
        return "CST";
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    function createStar(string _name, uint256 _tokenId) public {
        Star memory newStar = Star(_name);

        tokenIdToStarInfo[_tokenId] = newStar;

        _mint(msg.sender, _tokenId);
    }

    function lookUptokenIdToStarInfo(uint256 tokenId) public view returns(string) {
        return tokenIdToStarInfo[tokenId].name;
    }

    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        require(bytes(tokenIdToStarInfo[_tokenId1].name).length > 0);
        require(bytes(tokenIdToStarInfo[_tokenId2].name).length > 0);

        address owner1 = ownerOf(_tokenId1);
        address owner2 = ownerOf(_tokenId2);

        _removeTokenFrom(owner1, _tokenId1);
        _removeTokenFrom(owner2, _tokenId2);

        _addTokenTo(owner2, _tokenId1);
        _addTokenTo(owner1, _tokenId2);
    }

    function transferStar(address _to, uint256 _tokenId) public {
        require(_to != address(0));

        address owner1 = ownerOf(_tokenId);
        _removeTokenFrom(owner1, _tokenId);
        _addTokenTo(_to, _tokenId);

    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0);

        uint256 starCost = starsForSale[_tokenId];
        address starOwner = ownerOf(_tokenId);
        require(msg.value >= starCost);

        _removeTokenFrom(starOwner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);

        starOwner.transfer(starCost);

        if(msg.value > starCost) {
            msg.sender.transfer(msg.value - starCost);
        }
        starsForSale[_tokenId] = 0;
      }
}

