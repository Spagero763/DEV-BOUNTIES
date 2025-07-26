// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DevBountyToken is ERC20, Ownable {
    constructor() ERC20("DevBounty Token", "DBT") Ownable(msg.sender) {
        _mint(msg.sender, 10_000_000 * 1e18);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}