pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract YourToken is ERC20 {
    constructor() ERC20("Token", "TKN") public {
        _mint(msg.sender, 1000*10**18);
    }
}