// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ReputationTracker {
    mapping(address => uint256) public reputation;
    mapping(address => string) public githubUsername;

    address public oracle;

    modifier onlyOracle() {
        require(msg.sender == oracle, "Not authorized");
        _;
    }

    constructor(address _oracle) {
        oracle = _oracle;
    }

    function verifyGitHubProfile(address user, string calldata username) external onlyOracle {
        githubUsername[user] = username;
        reputation[user] = 100;
    }

    function updateReputation(address user, uint256 change, bool increase) external onlyOracle {
        if (increase) {
            reputation[user] += change;
        } else {
            reputation[user] -= change;
        }
    }
}
