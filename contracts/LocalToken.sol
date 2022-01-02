pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LocalToken is ERC20 {
    constructor() public ERC20("Local Token", "LOCAL"){
        _mint(msg.sender, 50000000000000000000000);
    }
    // 1000000000000000000000000 1 million tokens
    // 50000000000000000000000 50 000 tokens
}
