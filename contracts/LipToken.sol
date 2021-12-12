// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LipToken is ERC721, Ownable {
    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    uint256 COUNTER;

    uint256 fee = 1 ether;

    struct Lip {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    Lip[] public lips;

    event NewLip(address indexed owner, uint256 id, uint256 dna);

    // Helpers
    function _createRandomNum(uint256 _mod) internal view returns(uint256) {
        uint256 randomNum = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        return randomNum % _mod;
    }

    function updateFree(uint256 _fee) external onlyOwner() {
        fee = _fee;
    }

    function withdraw() external payable onlyOwner() {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }


    // Creattion
    function _createLip(string memory _name) internal {
        uint8 randRarity = uint8(_createRandomNum(100));
        uint256 randna = _createRandomNum(10 ** 16);
        Lip memory newList = Lip(_name, COUNTER, randna, 1, randRarity);
        lips.push(newList);
        _safeMint(msg.sender, COUNTER);
        emit NewLip(msg.sender, COUNTER, randna);
        COUNTER++;
    }

    function createRandomLip(string memory _name) public payable {
        require(msg.value >= fee, "The fee is not correct");
        _createLip(_name);
    }

    // Getter
    function getLips() public view returns(Lip[] memory) {
        return lips;
    }    
}
