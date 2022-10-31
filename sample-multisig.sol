pragma solidity ^0.4.25;

contract SimpleMultisig {

  address one;
  address two;

  mapping(address => bool) signed;

  constructor() public {
    one = 0xdC147A1C62C2C83C8E2f6688706376269A346B02;
    two = 0xa0993817cdeaBC68B506b7972eB2BbA0D739A4aC;
  }

  function Sign() public {
    require (msg.sender == one || msg.sender == two);
    require (!signed[msg.sender]); // signed[...] ต้องเป็น null
    signed[msg.sender] = true; 
    if (signed[one] && signed[two]) {
        Action();
    }
  }

  function Action() public returns (string) {
    require (signed[one] && signed[two]);
    // reset status
    signed[one] = false;
    signed[two] = false;

    return "Your action here";
  }

  function statusOneTwo() view public returns (bool, bool) {
        return (signed[one], signed[two]);
  }
}
