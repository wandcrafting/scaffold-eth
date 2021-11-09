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

  function withdraw(uint256 amountOfETH) public onlyOwner {
    require(amountOfETH <= address(this).balance, "Not Enough Ether");
    (bool sent, ) = msg.sender.call{value: amountOfETH}("");
    require(sent, "Failed to send Ether");
  }
  
  function sellTokens(uint256 numTokens) public {
    require(numTokens > 0, "Specify an amount of token greater than zero");

    uint256 userBalance = yourToken.balanceOf(msg.sender);
    require(userBalance >= numTokens, "Your balance is lower than the amount of tokens you want to sell");

    uint256 amountOfETHToTransfer = numTokens / tokensPerEth;
    uint256 ownerETHBalance = address(this).balance;
    require(ownerETHBalance >= amountOfETHToTransfer, "Vendor has not enough funds to accept the sell request");

    (bool sent) = yourToken.transferFrom(msg.sender, address(this), numTokens);
    require(sent, "Failed to transfer tokens from user to vendor");

    (bool sent,) = msg.sender.call{value: numTokens}("");
    require(sent, "Failed to send Ether");
  } 
}