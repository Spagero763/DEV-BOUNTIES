// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./DevBountyToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardDistributor is Ownable {
    DevBountyToken public dbt;

    constructor(address _dbt) Ownable(msg.sender) {
        dbt = DevBountyToken(_dbt);
    }

    function distributeReward(address recipient, uint256 baseAmount) external onlyOwner {
        dbt.mint(recipient, baseAmount);
    }
}