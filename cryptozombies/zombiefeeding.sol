// ZombieFeeding contract address:  0xe8277e04D378b6E53D4aD60f32e656ACCC3A8F2D

pragma solidity ^0.4.19; 
import "./zombiefactory.sol";
 
contract KittyInterface {  // จำลองว่าเป็น contract จากภายนอก
 function getKitty(uint256 _id) external view returns (
   bool isGestating,bool isReady,uint256 cooldownIndex,uint256 nextActionAt,
   uint256 siringWithId, uint256 birthTime,uint256 matronId,uint256 sireId,
   uint256 generation,uint256 genes
 );
}
 
contract ZombieFeeding is ZombieFactory {
 address ckAddress = 0xF54CfCf35A9A01AE30FCc5c58C13ef761db56d18; // hard-code
 KittyInterface kittyContract = KittyInterface(ckAddress); // KittyInterface
 
 function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public{   
   require(msg.sender == zombieToOwner[_zombieId]);
   Zombie storage myZombie = zombies[_zombieId];
   _targetDna = _targetDna % dnaModulus;
   uint newDna = (myZombie.dna + _targetDna) / 2;
   if (keccak256(_species) == keccak256("kitty")) {
     newDna = newDna - newDna % 100 + 99;
   }
   _createZombie("NoName", newDna);
 }
 
 function feedOnKitty(uint _zombieId, uint _kittyId) public {
   uint kittyDna;
   (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
   feedAndMultiply(_zombieId, kittyDna, "kitty");
 }
}
