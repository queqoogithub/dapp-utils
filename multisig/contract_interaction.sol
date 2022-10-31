pragma solidity^0.8.14;

interface ICounter {
    function count() external view returns (uint); 
    function countValue() external view returns (uint); // เหมือนกับอันบน
    function increment() external;
}

contract SimpleMultisigContractInteraction { // POC for MTS Safe

  address[] public owners;
  uint public numConfirmationsRequired;
  mapping(address => bool) public isOwner;

  struct SendTx {
    address beInteracted;
    bool executed;
    uint numConfirmations;
  }

  SendTx[] public sendTxs;

  modifier onlyOwner() {
    require(isOwner[msg.sender], "not owner");
    _;
  }

  modifier txExists(uint _txIndex) {
    require(_txIndex < sendTxs.length, "tx does not exist");
    _;
  }

  modifier notExecuted(uint _txIndex) {
    require(!sendTxs[_txIndex].executed, "tx already executed");
    _;
  }

  // tx index => owner address => isConfirmed 
  mapping(uint => mapping(address => bool)) public isConfirmed;
  
  constructor(address[] memory _owners, uint _numConfirmationsRequired) public {
    require(_owners.length > 0, "owners required");
    require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length, "invalid number of required confirmations");

    for (uint i = 0; i < _owners.length; i++) {
       address owner = _owners[i];
       require(owner != address(0), "invalid owner");
       require(!isOwner[owner], "owner is existed"); 
       isOwner[owner] = true;
       owners.push(owner);
    }
    numConfirmationsRequired = _numConfirmationsRequired;
  }

  function submitTx(address _interface) public onlyOwner {
    sendTxs.push(
      SendTx({
        beInteracted: _interface,
        executed: false,
        numConfirmations: 0
      })
    );
  } 

  function confirmTx(uint _sendTxIndex) public onlyOwner {
    require(!isConfirmed[_sendTxIndex][msg.sender], "tx have already confirmed by you before");
    SendTx storage transaction = sendTxs[_sendTxIndex];
    transaction.numConfirmations += 1;
    isConfirmed[_sendTxIndex][msg.sender] = true;
  }

  function exenTx(uint _sendTxIndex) public onlyOwner {
    SendTx storage transaction = sendTxs[_sendTxIndex];
    require(transaction.executed == false);
    require(transaction.numConfirmations >= numConfirmationsRequired, "cannot execute tx bec number of confirmation less than required number");
    ICounter(transaction.beInteracted).increment();
    transaction.executed = true;
  }
  
}
