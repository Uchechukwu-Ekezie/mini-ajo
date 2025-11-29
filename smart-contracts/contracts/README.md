# Ajosave Smart Contracts

Smart contracts for the Ajosave DeFi platform that digitizes traditional community savings practices (ROSCAs) using blockchain technology.

## Contract Architecture

### Base Contracts

- **`PoolBase.sol`**: Base abstract contract providing common functionality for all pool types
  - Member management
  - Contribution tracking
  - Penalty system
  - Security features (ReentrancyGuard, Pausable)

### Pool Types

#### 1. RotationalPool (`pools/RotationalPool.sol`)
Traditional Ajo/Esusu style pool where members take turns receiving payouts.

**Features:**
- Turn-based payouts in rotation order
- Automatic payout when all members contribute
- Configurable rotation order
- Penalty system for missed contributions

#### 2. TargetPool (`pools/TargetPool.sol`)
Goal-based pool that locks funds until target amount is reached or deadline passes.

**Features:**
- Target amount tracking
- Deadline mechanism
- Flexible distribution (equal split or proportional)
- Partial goal handling

#### 3. FlexiblePool (`pools/FlexiblePool.sol`)
Flexible pool allowing deposits/withdrawals anytime with yield generation.

**Features:**
- Deposit and withdraw anytime
- Yield calculation based on time
- Proportional yield distribution
- Minimum deposit/withdrawal amounts

## Development

### Prerequisites

- Node.js 18+
- npm or yarn

### Installation

Dependencies are already installed with the main project:
```bash
npm install
```

### Compile Contracts

```bash
npm run compile
```

### Run Tests

```bash
npm run test
```

### Deploy Contracts

**Local network:**
```bash
npm run node  # Start Hardhat node in another terminal
npm run deploy:local
```

**Base Sepolia Testnet:**
```bash
npm run deploy:baseSepolia
```

**Base Mainnet:**
```bash
npm run deploy:base
```

### Verify Contracts

After deployment, verify on BaseScan:
```bash
npx hardhat verify --network baseSepolia <CONTRACT_ADDRESS> <CONSTRUCTOR_ARGS>
```

## Security

- Contracts use OpenZeppelin's battle-tested security libraries
- Reentrancy protection on all external functions
- Access control with Ownable
- Pausable functionality for emergencies
- Comprehensive input validation

## Testing

Tests are located in the `test/` directory. Run all tests:

```bash
npm run test
```

For gas reporting:
```bash
npm run test:gas
```

## Network Configuration

The project is configured for Base network:
- **Base Sepolia Testnet**: Chain ID 84532
- **Base Mainnet**: Chain ID 8453

RPC URLs and API keys should be set in `.env` file (see `.env.example`).

## Documentation

- Contracts use NatSpec comments for documentation
- Generate documentation with:
  ```bash
  npx hardhat docgen
  ```

## License

MIT License

