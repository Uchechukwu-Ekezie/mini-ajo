# Ajosave Smart Contracts

This directory contains all smart contract code for the Ajosave DeFi platform.

## 📁 Directory Structure

```
smart-contracts/
├── contracts/           # Solidity source files
│   ├── base/           # Base contracts
│   ├── interfaces/     # Contract interfaces
│   └── pools/          # Pool implementations
├── scripts/            # Deployment scripts
├── test/               # Test files
├── artifacts/          # Compiled contracts (generated)
├── cache/              # Hardhat cache (generated)
├── hardhat.config.js   # Hardhat configuration
└── README.md           # This file
```

## 🚀 Quick Start

### From Project Root

All Hardhat commands are available from the project root via npm scripts:

```bash
# Compile contracts
npm run compile

# Run tests
npm run test

# Deploy to local network
npm run node          # Terminal 1
npm run deploy:local  # Terminal 2

# Deploy to Base Sepolia
npm run deploy:baseSepolia

# Deploy to Base Mainnet
npm run deploy:base
```

### From This Directory

You can also run commands directly from this directory:

```bash
cd smart-contracts

# Compile
npx hardhat compile

# Test
npx hardhat test

# Deploy
npx hardhat run scripts/deploy.ts --network baseSepolia
```

## 📚 Contract Documentation

See:
- `contracts/README.md` - Detailed contract documentation
- `SMART_CONTRACTS_SETUP.md` - Setup and configuration guide

## 🔧 Configuration

- Network configuration: `hardhat.config.js`
- Environment variables: Create `.env` in project root (see `.env.example`)

## 📝 Contracts

### Base Contracts
- **PoolBase.sol** - Base contract with common functionality

### Pool Types
- **RotationalPool.sol** - Traditional Ajo/Esusu style pool
- **TargetPool.sol** - Goal-based savings pool
- **FlexiblePool.sol** - Flexible deposits/withdrawals with yield

## 🧪 Testing

Tests are located in the `test/` directory. Run all tests:

```bash
npm run test
```

## 🔐 Deployment

Before deploying, ensure you have:
1. Created `.env` file with required variables
2. Funded your deployer wallet with ETH
3. Tested contracts on testnet first

## 📖 Learn More

For detailed documentation, see the contract-specific README files.

