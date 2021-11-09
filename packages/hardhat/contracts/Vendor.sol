pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable{

  YourToken yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }
  
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  
  function buyTokens() public payable {
    require(msg.value > 0, "no ether sent");
    
    uint256 amountOfTokens = msg.value * tokensPerEth;
    
    uint256 vendorBalance = yourToken.balanceOf(address(this));
    require(vendorBalance >= amountOfTokens, "Vendor contract has not enough tokens in its balance");

    
    (bool sent) = yourToken.transfer(msg.sender, amountOfTokens);
    require(sent, "Failed to transfer token to user");
    
    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }
 
}


  //ToDo: create a sellTokens() function:

  //ToDo: create a withdraw() function that lets the owner, you can 
  //use the Ownable.sol import above: