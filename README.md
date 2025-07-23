# DevBounty Protocol 🛠️💰

DevBounty is an onchain protocol for funding and rewarding GitHub issue bounties, powered by Base.

## Features
- 🔐 Escrow-based bounty payments
- 💼 GitHub reputation tracker
- 🪙 ERC-20 reward token (DBT)
- 🏗️ Modular contract architecture

## Contracts
- `DevBountyToken`: Reward token (DBT)
- `BountyFactory`: Create/manage bounties
- `EscrowPayments`: Locks/release payments
- `ReputationTracker`: GitHub-based reputation
- `RewardDistributor`: Mints DBT rewards

## Deployment (Base Sepolia)
1. Deploy `DevBountyToken`
2. Deploy `ReputationTracker`
3. Deploy `EscrowPayments`
4. Deploy `RewardDistributor`
5. Deploy `BountyFactory` with addresses of above

## Verification
All contracts deployed and verified on [BaseScan Testnet](https://sepolia.basescan.org).

## License
MIT
