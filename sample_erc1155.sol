pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

string public name = "Aligator Gangster";
string public symbol = "AGG";

contract aligatorGang is ERC1155 {
    uint256 public constant AligatorJo = 1;
    uint256 public constant AligatorKo = 2;
    uint256 public constant AligatorFo = 3;

    constructor() ERC1155("https://ipfs.io/ipfs/bafybeiasv25bzuv2xqm3coriv6vt76hie7mia25y372yr2bqfmn6lfg6ou/{id}.json") {
        _mint(msg.sender, AligatorJo, 1, "");
        _mint(msg.sender, AligatorKo, 3, "");
        _mint(msg.sender, AligatorFo, 5, "");
    }

    // to overwrite the URI function to return the file name as a string
    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "https://ipfs.io/ipfs/bafybeiasv25bzuv2xqm3coriv6vt76hie7mia25y372yr2bqfmn6lfg6ou/",
                Strings.toString(_tokenid),".json"
            )
        );
    }
}
