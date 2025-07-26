// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ReputationTracker.sol";
import "./EscrowPayments.sol";
import "./DevBountyToken.sol";

contract BountyFactory {
    struct Bounty {
        uint256 id;
        string githubIssueUrl;
        address creator;
        address solver;
        uint256 escrowId;
        bool completed;
    }

    uint256 public bountyCounter;
    mapping(uint256 => Bounty) public bounties;

    DevBountyToken public dbt;
    ReputationTracker public reputation;
    EscrowPayments public escrow;

    event BountyCreated(uint256 indexed bountyId, address indexed creator, string githubIssueUrl);
    event BountySubmitted(uint256 indexed bountyId, address indexed solver);
    event BountyCompleted(uint256 indexed bountyId);

    constructor(
        address _dbt,
        address _reputation,
        address _escrow
    ) {
        dbt = DevBountyToken(_dbt);
        reputation = ReputationTracker(_reputation);
        escrow = EscrowPayments(_escrow);
    }

    function createBounty(
        string calldata githubIssueUrl,
        address solver,
        uint256 amount
    ) external {
        require(amount > 0, "Reward must be > 0");
        require(solver != address(0), "Invalid solver");

        // Transfer DBT tokens from creator to factory
        dbt.transferFrom(msg.sender, address(this), amount);

        // Approve Escrow contract to lock funds
        dbt.approve(address(escrow), amount);

        // Lock funds in escrow
        uint256 escrowId = escrow.lock(address(dbt), solver, amount);

        // Store bounty
        bounties[bountyCounter] = Bounty({
            id: bountyCounter,
            githubIssueUrl: githubIssueUrl,
            creator: msg.sender,
            solver: solver,
            escrowId: escrowId,
            completed: false
        });

        emit BountyCreated(bountyCounter, msg.sender, githubIssueUrl);
        bountyCounter++;
    }

    function submitSolution(uint256 bountyId) external {
        Bounty storage b = bounties[bountyId];
        require(msg.sender == b.solver, "Not assigned solver");
        require(!b.completed, "Bounty already completed");

        emit BountySubmitted(bountyId, msg.sender);
    }

    function completeBounty(uint256 bountyId) external {
        Bounty storage b = bounties[bountyId];
        require(msg.sender == b.creator, "Only creator can complete");
        require(!b.completed, "Already completed");

        b.completed = true;

        // Release escrowed payment to solver
        escrow.release(b.escrowId);

        // Update reputation
        reputation.updateReputation(b.solver, 1, true); // increase by 1

        emit BountyCompleted(bountyId);
    }
}