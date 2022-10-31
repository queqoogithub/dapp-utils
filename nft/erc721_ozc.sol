// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract My721Token is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping (uint256 => string) private _tokenURIs;

    constructor() ERC721("MyToken", "MTK") {}

    function uri(uint256 tokenId) public view 
    returns (string memory) { 
        return(_tokenURIs[tokenId]); 
    } 

    function _setTokenURI(uint256 tokenId, string memory tokenURI)
    private {
         _tokenURIs[tokenId] = tokenURI; 
    } 

    function mintNFT(address to, string memory tokenURI) public onlyOwner {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        
        _safeMint(to, newItemId);
        _setTokenURI(newItemId, tokenURI);
    }
}
