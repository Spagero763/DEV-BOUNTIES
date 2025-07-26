// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EscrowPayments is Ownable {
    enum Status { Locked, Released, Refunded }

    struct Escrow {
        address token;
        address sender;
        address recipient;
        uint256 amount;
        Status status;
    }

    uint256 public escrowCounter;
    mapping(uint256 => Escrow) public escrows;

    event Locked(uint256 escrowId, address indexed token, address indexed sender, address indexed recipient, uint256 amount);
    event Released(uint256 escrowId);
    event Refunded(uint256 escrowId);

    constructor() Ownable(msg.sender) {}

    function lock(address token, address recipient, uint256 amount) external returns (uint256) {
        require(recipient != address(0), "Invalid recipient");
        require(amount > 0, "Amount must be greater than 0");

        IERC20(token).transferFrom(msg.sender, address(this), amount);

        escrows[escrowCounter] = Escrow({
            token: token,
            sender: msg.sender,
            recipient: recipient,
            amount: amount,
            status: Status.Locked
        });

        emit Locked(escrowCounter, token, msg.sender, recipient, amount);
        escrowCounter++;
        return escrowCounter - 1;
    }

    function release(uint256 escrowId) external onlyOwner {
        Escrow storage esc = escrows[escrowId];
        require(esc.status == Status.Locked, "Escrow not locked");

        esc.status = Status.Released;
        IERC20(esc.token).transfer(esc.recipient, esc.amount);

        emit Released(escrowId);
    }

    function refund(uint256 escrowId) external onlyOwner {
        Escrow storage esc = escrows[escrowId];
        require(esc.status == Status.Locked, "Escrow not locked");

        esc.status = Status.Refunded;
        IERC20(esc.token).transfer(esc.sender, esc.amount);

        emit Refunded(escrowId);
    }
}