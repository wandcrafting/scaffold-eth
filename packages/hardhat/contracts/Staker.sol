pragma solidity >=0.6.0 <0.7.0;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Staker {

  ExampleExternalContract public exampleExternalContract;
  
  mapping(address => uint256) public balances;
  uint256 public constant threshold = 1 ether;
  uint256 public deadline = now + 30 seconds;
  uint256 public contract_balance = 0;
  bool public openForWithdraw = false;

  event Stake(address _address, uint256 _ether);
  
  modifier onlyAfterDeadline() {
    require(now > deadline);
    _;
  }

  constructor(address exampleExternalContractAddress) public {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }
  
  function stake(address _address, uint256 _ether) public payable {
    require(_address != address(0));
    require(_ether > 0);
    balances[_address] += _ether;
    contract_balance += _ether;
    emit Stake(_address, _ether);
  }
  
  function execute() onlyAfterDeadline public {
    if (contract_balance == threshold) {
      uint256 amount = contract_balance;
      contract_balance = 0;
      exampleExternalContract.complete{value: amount}();
    } else {
      openForWithdraw = true;
    }
  }
  
  function withdraw() onlyAfterDeadline public payable {
    require(openForWithdraw);
    amount = balances[msg.sender];
    balances[msg.sender] = 0;
    (bool sent, ) = msg.sender.call{value: amount}();
    require(sent, "Failed to send Ether");
  }
  
  function timeLeft() public view returns (uint256) {
    if (now >= deadline) {
      return 0;
    }
    return deadline - now;
  }
  
}