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
    _ ;
  }

  modifier notCompleted() {
    require(exampleExternalContract.completed() == false);
    _ ;
  }

  constructor(address exampleExternalContractAddress) public {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }
  
  function stake() public payable notCompleted {
    require(msg.sender != address(0));
    require(msg.value > 0);
    balances[msg.sender] += msg.value;
    contract_balance += msg.value;
    emit Stake(msg.sender, msg.value);
  }
  
  function execute() onlyAfterDeadline notCompleted public {
    if (contract_balance >= threshold) {
      uint256 amount = contract_balance;
      contract_balance = 0;
      exampleExternalContract.complete{value: amount}();
    } else {
      openForWithdraw = true;
    }
  }
  
  function withdraw() notCompleted onlyAfterDeadline public {
    require(openForWithdraw);
    uint256 amount = balances[msg.sender];
    balances[msg.sender] = 0;
    contract_balance -= amount;
    (bool sent, ) = msg.sender.call{value: amount}("");
    require(sent, "Failed to send Ether");
  }
  
  function timeLeft() public view returns (uint256) {
    if (now >= deadline) {
      return 0;
    } else {
      return deadline - now;
    }
  }
  
}