# Ajosave - GitHub Issues

> **Project Overview:** Ajosave is a decentralized finance (DeFi) platform that digitizes traditional community savings practices (Ajo, Esusu, Tontine, ROSCAs) using blockchain technology. Built for African communities and accessible globally.

---

## 🔴 High Priority

### Issue #1: Design and Implement Smart Contract Architecture for Pool Templates
**Priority:** High | **Type:** Feature | **Labels:** `smart-contracts`, `solidity`, `core-feature`, `security`

**Description:**
Create the foundational smart contract architecture to support three pool types: Rotational Savings, Target Pool, and Flexible Pool. Contracts must enforce rules automatically, handle penalties, grace periods, and be non-custodial.

**Acceptance Criteria:**
- [ ] Design smart contract architecture for all three pool types
- [ ] Create base abstract contract for common pool functionality
- [ ] Implement Rotational Savings contract with turn-based payouts
- [ ] Implement Target Pool contract with deadline/goal-based locking
- [ ] Implement Flexible Pool contract with deposit/withdraw capabilities
- [ ] Add automatic penalty enforcement mechanisms
- [ ] Implement grace period logic for late contributions
- [ ] Ensure non-custodial design (no single treasury holder)
- [ ] Write comprehensive NatSpec documentation
- [ ] Design upgradeable pattern (if needed) using proxy contracts

**Technical Notes:**
- Use Solidity 0.8.x or latest stable version
- Follow OpenZeppelin standards for security
- Consider gas optimization for Base network
- Plan for contract verification on Sourcify
- Design with reentrancy protection in mind

**Related Files:**
- Create `contracts/` directory structure
- `contracts/base/PoolBase.sol`
- `contracts/pools/RotationalPool.sol`
- `contracts/pools/TargetPool.sol`
- `contracts/pools/FlexiblePool.sol`

---

### Issue #2: Implement Rotational Savings Pool Contract with Automated Payouts
**Priority:** High | **Type:** Feature | **Labels:** `smart-contracts`, `rotational-pool`, `automation`, `high-priority`

**Description:**
Build the Rotational Savings (Ajo/Esusu) pool contract that manages turn-based payouts, tracks rotation order, and automatically distributes funds when it's a member's turn.

**Acceptance Criteria:**
- [ ] Implement rotation order determination (random, sequential, or configurable)
- [ ] Create function to handle automatic payouts when conditions are met
- [ ] Add contribution tracking per member per round
- [ ] Implement penalty system for missed contributions
- [ ] Add grace period logic before penalties apply
- [ ] Create events for all major state changes
- [ ] Handle edge cases (member leaves mid-cycle, etc.)
- [ ] Add view functions for pool status and member positions
- [ ] Write comprehensive tests (aim for 100% coverage)

**Technical Notes:**
- Ensure atomic operations for payouts
- Consider using Chainlink Automation or Gelato for scheduled actions
- Design for predictable gas costs
- Include pause mechanism for emergencies

**Deliverables:**
- `contracts/pools/RotationalPool.sol`
- `test/RotationalPool.test.sol`
- Deployment scripts

---

### Issue #3: Implement Target Pool Contract with Goal/Deadline-Based Locking
**Priority:** High | **Type:** Feature | **Labels:** `smart-contracts`, `target-pool`, `locking-mechanism`, `high-priority`

**Description:**
Create the Target Pool contract that locks contributions until either the collective goal amount is reached or a deadline expires, then distributes funds according to predefined rules.

**Acceptance Criteria:**
- [ ] Implement goal amount tracking and validation
- [ ] Create deadline mechanism with automatic distribution
- [ ] Add contribution locking until goal/deadline is met
- [ ] Define distribution rules (equal split, proportional, or configurable)
- [ ] Handle partial goal achievement scenarios
- [ ] Add ability to extend deadline (if governance allows)
- [ ] Implement early unlock conditions (if all members agree)
- [ ] Create events for milestones (50% funded, 75% funded, etc.)
- [ ] Write comprehensive tests

**Technical Notes:**
- Consider time-based distribution using block.timestamp
- Plan for timezone considerations
- Include mechanisms for handling stuck funds

**Deliverables:**
- `contracts/pools/TargetPool.sol`
- `test/TargetPool.test.sol`

---

### Issue #4: Implement Flexible Pool with Yield Strategy Integration
**Priority:** High | **Type:** Feature | **Labels:** `smart-contracts`, `flexible-pool`, `defi`, `yield-farming`, `high-priority`

**Description:**
Build the Flexible Pool contract that allows members to deposit/withdraw anytime while automatically routing idle funds into yield-generating strategies on Base.

**Acceptance Criteria:**
- [ ] Create deposit/withdraw functions with no time locks
- [ ] Implement yield strategy router (integrate with Base DeFi protocols)
- [ ] Add balance tracking per member with interest accrual
- [ ] Create automatic rebalancing mechanism for idle funds
- [ ] Implement strategy selection (Aave, Compound, or multiple strategies)
- [ ] Add yield distribution logic (proportional to deposits)
- [ ] Handle strategy changes and migrations
- [ ] Add slippage protection for DeFi interactions
- [ ] Create events for yield accrual and strategy updates
- [ ] Write comprehensive tests including integration tests with mock protocols

**Technical Notes:**
- Research Base ecosystem DeFi protocols for yield strategies
- Consider using Yearn vaults or similar aggregators
- Implement access controls for strategy changes
- Plan for gas optimization with batch operations

**Deliverables:**
- `contracts/pools/FlexiblePool.sol`
- `contracts/strategies/YieldStrategy.sol`
- `test/FlexiblePool.test.sol`
- Integration tests with mock protocols

---

### Issue #5: Set Up Supabase Database Schema for Pool Activity Feeds
**Priority:** High | **Type:** Feature | **Labels:** `backend`, `database`, `supabase`, `activity-feeds`, `high-priority`

**Description:**
Create Supabase database schema to mirror blockchain events for off-chain activity feeds, enabling fast queries and rich context for pool activities without relying solely on blockchain queries.

**Acceptance Criteria:**
- [ ] Design database schema for pools, members, transactions, and activities
- [ ] Create tables: `pools`, `members`, `contributions`, `payouts`, `penalties`, `activities`
- [ ] Set up relationships and foreign keys
- [ ] Create indexes for common query patterns
- [ ] Design activity feed table structure with rich metadata
- [ ] Set up Row Level Security (RLS) policies
- [ ] Create database migrations with versioning
- [ ] Add database functions for common queries
- [ ] Set up Supabase project and configure connection

**Technical Notes:**
- Use Supabase PostgreSQL database
- Design for horizontal scaling if needed
- Consider partitioning for large activity tables
- Include timestamps for all records

**Deliverables:**
- `supabase/migrations/` directory with migration files
- Database schema documentation
- Supabase configuration

---

### Issue #6: Implement Event Indexer/Listener to Sync Blockchain Events to Supabase
**Priority:** High | **Type:** Feature | **Labels:** `backend`, `indexer`, `blockchain-sync`, `events`, `high-priority`

**Description:**
Create a service that listens to smart contract events and syncs them to Supabase database for fast off-chain queries and activity feeds.

**Acceptance Criteria:**
- [ ] Set up event listener service (Node.js worker or similar)
- [ ] Listen to all pool-related events (contributions, payouts, penalties, etc.)
- [ ] Parse and normalize event data
- [ ] Insert/update records in Supabase
- [ ] Handle event replay for missed blocks
- [ ] Add error handling and retry logic
- [ ] Create idempotency mechanism (prevent duplicate entries)
- [ ] Add logging and monitoring
- [ ] Handle chain reorgs gracefully
- [ ] Create service deployment configuration

**Technical Notes:**
- Consider using Viem or Ethers.js for event listening
- Use Base RPC endpoints or Alchemy/Infura
- Plan for high-volume event processing
- Consider using message queue for reliability

**Deliverables:**
- `services/indexer/` directory
- `services/indexer/eventListener.ts`
- `services/indexer/databaseSync.ts`
- Deployment configuration (Docker, etc.)

---

## 🟡 Medium Priority

### Issue #7: Create Pool Creation UI with Guided Setup Wizard
**Priority:** Medium | **Type:** Feature | **Labels:** `frontend`, `ui`, `ux`, `pool-creation`, `wizard`

**Description:**
Build an intuitive, guided setup wizard for creating pools that helps users understand each pool type and configure settings appropriately.

**Acceptance Criteria:**
- [ ] Design multi-step wizard UI for pool creation
- [ ] Create pool type selection screen with explanations
- [ ] Build configuration forms for each pool type:
  - Rotational: member list, contribution amount, rotation order, penalties
  - Target: goal amount, deadline, distribution rules
  - Flexible: minimum deposit, yield strategy selection
- [ ] Add validation for all inputs
- [ ] Show estimated gas costs before submission
- [ ] Display pool summary before final creation
- [ ] Handle wallet connection and transaction signing
- [ ] Show loading states and transaction progress
- [ ] Add error handling and user-friendly messages
- [ ] Create responsive design for mobile (Base app)

**Technical Notes:**
- Use OnchainKit for wallet integration
- Consider using React Hook Form for form management
- Design with African users in mind (clear explanations, multiple languages?)
- Add tooltips and help text throughout

**Files to Create:**
- `app/create-pool/page.tsx`
- `app/create-pool/components/PoolTypeSelector.tsx`
- `app/create-pool/components/RotationalConfig.tsx`
- `app/create-pool/components/TargetConfig.tsx`
- `app/create-pool/components/FlexibleConfig.tsx`

---

### Issue #8: Build Pool Dashboard with Real-Time Activity Feed
**Priority:** Medium | **Type:** Feature | **Labels:** `frontend`, `dashboard`, `activity-feed`, `real-time`

**Description:**
Create a comprehensive pool dashboard that displays pool status, member information, and a real-time activity feed synced from Supabase.

**Acceptance Criteria:**
- [ ] Design pool overview dashboard layout
- [ ] Display pool metrics (total contributed, members, status, etc.)
- [ ] Create member list with contribution status
- [ ] Build activity feed component with real-time updates (Supabase realtime)
- [ ] Show transaction history with links to Base explorer
- [ ] Add filters for activity types (contributions, payouts, penalties)
- [ ] Display upcoming actions (next payout, deadline countdown, etc.)
- [ ] Add quick actions (contribute, withdraw, claim payout)
- [ ] Implement pagination for large activity lists
- [ ] Create responsive design

**Technical Notes:**
- Use Supabase Realtime for live updates
- Integrate with Base blockchain explorer API
- Consider caching for frequently accessed data
- Use React Query for data fetching and caching

**Files to Create:**
- `app/pool/[id]/page.tsx`
- `app/pool/[id]/components/PoolOverview.tsx`
- `app/pool/[id]/components/ActivityFeed.tsx`
- `app/pool/[id]/components/MemberList.tsx`

---

### Issue #9: Implement Automated Reminder System for Contributions
**Priority:** Medium | **Type:** Feature | **Labels:** `backend`, `automation`, `notifications`, `reminders`

**Description:**
Build an automated system that sends reminders to pool members before contribution deadlines, using Farcaster notifications or other channels.

**Acceptance Criteria:**
- [ ] Create reminder scheduling service
- [ ] Calculate reminder times (e.g., 24h before deadline, 1h before)
- [ ] Integrate with Farcaster notification system (via MiniKit)
- [ ] Add email/SMS reminder options (if applicable)
- [ ] Create reminder message templates
- [ ] Track reminder delivery status
- [ ] Allow members to configure reminder preferences
- [ ] Handle missed contributions and escalate to penalty phase
- [ ] Add admin override for reminder timing

**Technical Notes:**
- Use cron jobs or task scheduler for reminders
- Consider using Farcaster notifications API
- Design reminder messages to be clear and actionable
- Handle timezone differences appropriately

**Deliverables:**
- `services/reminders/` directory
- Reminder scheduling logic
- Notification templates

---

### Issue #10: Add Smart Contract Verification and Security Audit Preparation
**Priority:** Medium | **Type:** Enhancement | **Labels:** `security`, `smart-contracts`, `verification`, `audit`

**Description:**
Prepare contracts for security audit and ensure all contracts are verified on Sourcify for transparency.

**Acceptance Criteria:**
- [ ] Write comprehensive test suite (aim for 100% coverage)
- [ ] Add fuzz testing for critical functions
- [ ] Create formal verification specifications (if applicable)
- [ ] Verify all contracts on Sourcify
- [ ] Document known limitations and edge cases
- [ ] Create security audit checklist
- [ ] Set up Foundry or Hardhat for testing
- [ ] Write documentation for external auditors
- [ ] Add gas optimization analysis
- [ ] Create deployment verification script

**Technical Notes:**
- Use tools like Slither or Mythril for static analysis
- Consider engaging professional audit firms
- Document all security assumptions
- Create bug bounty program guidelines

**Deliverables:**
- Complete test suite
- Verification scripts
- Audit documentation
- Security analysis reports

---

### Issue #11: Implement Penalty System with Configurable Rules
**Priority:** Medium | **Type:** Feature | **Labels:** `smart-contracts`, `penalties`, `governance`, `rules`

**Description:**
Build a flexible penalty system that allows pool creators to configure penalty amounts, grace periods, and enforcement rules.

**Acceptance Criteria:**
- [ ] Design penalty configuration structure
- [ ] Implement penalty calculation logic
- [ ] Add grace period before penalties apply
- [ ] Create penalty distribution mechanism (to other members, pool treasury, or burned)
- [ ] Allow penalty rules to be set at pool creation
- [ ] Add view functions to calculate potential penalties
- [ ] Create events for penalty applications
- [ ] Handle partial contributions with proportional penalties
- [ ] Add ability to waive penalties (if governance allows)
- [ ] Write comprehensive tests

**Technical Notes:**
- Ensure penalties are fair and transparent
- Consider maximum penalty caps
- Document penalty logic clearly for users

**Deliverables:**
- Penalty calculation module
- Configuration interface
- Tests and documentation

---

### Issue #12: Create Member Management System (Join, Leave, Invite)
**Priority:** Medium | **Type:** Feature | **Labels:** `frontend`, `backend`, `member-management`, `invites`

**Description:**
Build functionality for pool creators and members to manage membership: invite others, join pools, and handle member exits.

**Acceptance Criteria:**
- [ ] Create invite link generation system
- [ ] Build join pool interface (via invite link or public pools)
- [ ] Implement member verification (Farcaster FID + wallet)
- [ ] Handle member exit scenarios (withdrawal of contributions if allowed)
- [ ] Add member role management (creator, admin, member)
- [ ] Create member list with contribution history
- [ ] Add member removal functionality (if governance allows)
- [ ] Handle edge cases (member leaves mid-cycle)
- [ ] Create events for membership changes
- [ ] Write tests for membership flows

**Technical Notes:**
- Consider using Farcaster social graph for invites
- Design clear rules for member exits
- Handle funds redistribution when members leave

**Files to Create:**
- `app/pool/[id]/invite/page.tsx`
- `app/pool/[id]/members/page.tsx`
- Membership management components

---

### Issue #13: Build Transaction Status Tracking and Receipt System
**Priority:** Medium | **Type:** Feature | **Labels:** `frontend`, `backend`, `transactions`, `tracking`

**Description:**
Create a comprehensive transaction tracking system that shows pending, confirmed, and failed transactions with detailed receipts.

**Acceptance Criteria:**
- [ ] Display transaction status in real-time
- [ ] Show transaction receipts with all details
- [ ] Add links to Base explorer for each transaction
- [ ] Handle transaction failures gracefully
- [ ] Implement transaction retry mechanism
- [ ] Create transaction history view
- [ ] Add filters for transaction types
- [ ] Show gas costs and confirmation times
- [ ] Add export functionality (CSV/PDF)
- [ ] Create email/SMS receipt option (optional)

**Technical Notes:**
- Use wagmi hooks for transaction status
- Poll blockchain for confirmation status
- Store transaction hashes in Supabase

**Files to Create:**
- Transaction status components
- Receipt generation logic
- Transaction history page

---

### Issue #14: Implement Pool Discovery and Search Functionality
**Priority:** Medium | **Type:** Feature | **Labels:** `frontend`, `search`, `discovery`, `explore`

**Description:**
Create an explore/discover page where users can find public pools to join, filtered by pool type, status, and other criteria.

**Acceptance Criteria:**
- [ ] Design pool discovery page layout
- [ ] Create search functionality (by name, creator, tags)
- [ ] Add filters (pool type, status, contribution amount, etc.)
- [ ] Display pool cards with key information
- [ ] Add sorting options (newest, most members, highest goal, etc.)
- [ ] Show pool verification badges
- [ ] Add "trending" or "popular" pools section
- [ ] Create pagination or infinite scroll
- [ ] Add pool preview modal
- [ ] Implement responsive design

**Technical Notes:**
- Query pools from Supabase for fast results
- Consider adding full-text search
- Cache popular pools for performance

**Files to Create:**
- `app/explore/page.tsx`
- `app/explore/components/PoolCard.tsx`
- `app/explore/components/SearchFilters.tsx`

---

### Issue #15: Add Multi-Language Support (i18n) for African Languages
**Priority:** Medium | **Type:** Enhancement | **Labels:** `i18n`, `localization`, `ux`, `accessibility`

**Description:**
Implement internationalization to support multiple languages common in African communities (English, French, Swahili, Yoruba, etc.) to improve accessibility.

**Acceptance Criteria:**
- [ ] Set up i18n library (next-intl or react-i18next)
- [ ] Create translation files for core languages
- [ ] Translate all UI strings and error messages
- [ ] Add language selector in UI
- [ ] Detect user's preferred language
- [ ] Translate documentation and help text
- [ ] Ensure proper RTL support if needed
- [ ] Test with native speakers
- [ ] Create contribution guide for translators

**Technical Notes:**
- Start with English, French, and Swahili
- Consider community contributions for additional languages
- Use proper date/number formatting per locale

**Files to Create:**
- `locales/` directory with translation files
- Language detection and selection logic

---

## 🟢 Low Priority / Nice to Have

### Issue #16: Implement Governance System for Pool Rules Changes
**Priority:** Low | **Type:** Feature | **Labels:** `governance`, `smart-contracts`, `voting`, `advanced`

**Description:**
Add an on-chain governance system that allows pool members to vote on rule changes, penalty adjustments, and other pool parameters.

**Acceptance Criteria:**
- [ ] Design governance proposal structure
- [ ] Create voting mechanism (simple majority, quorum-based)
- [ ] Add proposal creation interface
- [ ] Implement vote tracking and tallying
- [ ] Add timelock for executed proposals
- [ ] Create governance UI for proposals and voting
- [ ] Handle delegation of voting power
- [ ] Write tests for governance flows

**Technical Notes:**
- Consider gas costs for voting
- Use existing governance patterns (Compound, Aave)
- Make governance optional per pool

---

### Issue #17: Create Analytics Dashboard for Pool Performance
**Priority:** Low | **Type:** Feature | **Labels:** `analytics`, `dashboard`, `data-visualization`

**Description:**
Build an analytics dashboard that shows pool performance metrics, member contribution patterns, and yield statistics.

**Acceptance Criteria:**
- [ ] Design analytics dashboard layout
- [ ] Create charts for contribution trends
- [ ] Show yield performance for flexible pools
- [ ] Display member participation rates
- [ ] Add export functionality for reports
- [ ] Create pool comparison tools
- [ ] Add time-based filtering
- [ ] Integrate with data visualization library (Recharts, D3)

**Technical Notes:**
- Query analytics from Supabase
- Consider caching expensive queries
- Respect user privacy in analytics

---

### Issue #18: Add Social Features (Comments, Reactions on Activities)
**Priority:** Low | **Type:** Feature | **Labels:** `social`, `frontend`, `community`, `engagement`

**Description:**
Enhance community engagement by allowing members to comment on pool activities and react to contributions/payouts.

**Acceptance Criteria:**
- [ ] Design comment system UI
- [ ] Create reactions system (emojis on activities)
- [ ] Store comments/reactions in Supabase
- [ ] Add moderation capabilities
- [ ] Show comment threads on activities
- [ ] Add notifications for mentions/replies
- [ ] Integrate with Farcaster profiles
- [ ] Implement real-time updates

**Technical Notes:**
- Consider using Farcaster casts for comments?
- Design moderation system early
- Respect privacy preferences

---

### Issue #19: Implement Pool Templates and Presets
**Priority:** Low | **Type:** Feature | **Labels:** `templates`, `ux`, `onboarding`, `community`

**Description:**
Create pre-configured pool templates based on common use cases (wedding savings, school fees, business capital, etc.) to simplify pool creation.

**Acceptance Criteria:**
- [ ] Research common ROSCA use cases
- [ ] Design template structure
- [ ] Create templates for popular use cases
- [ ] Build template selection UI
- [ ] Allow template customization
- [ ] Add template marketplace (community-submitted)
- [ ] Create template documentation
- [ ] Add template preview

**Technical Notes:**
- Start with 5-10 common templates
- Allow community to submit templates
- Make templates easily customizable

---

### Issue #20: Build Mobile-First Responsive Design Improvements
**Priority:** Low | **Type:** Enhancement | **Labels:** `frontend`, `mobile`, `responsive`, `ux`

**Description:**
Optimize the entire application for mobile devices, considering that many users in target markets primarily use mobile devices.

**Acceptance Criteria:**
- [ ] Audit current mobile experience
- [ ] Optimize all forms for mobile input
- [ ] Improve touch targets and spacing
- [ ] Test on various screen sizes
- [ ] Optimize images and assets for mobile
- [ ] Improve loading performance on mobile networks
- [ ] Add mobile-specific navigation patterns
- [ ] Test on actual mobile devices

**Technical Notes:**
- Use mobile-first CSS approach
- Consider Progressive Web App (PWA) features
- Test on low-end devices

---

## 📝 Infrastructure & DevOps

### Issue #21: Set Up CI/CD Pipeline and Automated Testing
**Priority:** Medium | **Type:** DevOps | **Labels:** `ci-cd`, `testing`, `devops`, `automation`

**Description:**
Create a robust CI/CD pipeline that runs tests, lints code, builds contracts, and deploys to testnet/mainnet automatically.

**Acceptance Criteria:**
- [ ] Set up GitHub Actions workflows
- [ ] Add automated test runs on PRs
- [ ] Create contract compilation and verification steps
- [ ] Set up automated deployment to testnet
- [ ] Add manual approval for mainnet deployments
- [ ] Create environment-specific configurations
- [ ] Add deployment rollback procedures
- [ ] Document deployment process

**Deliverables:**
- `.github/workflows/` directory
- Deployment scripts
- CI/CD documentation

---

### Issue #22: Implement Comprehensive Monitoring and Alerting
**Priority:** Medium | **Type:** DevOps | **Labels:** `monitoring`, `logging`, `alerts`, `observability`

**Description:**
Set up monitoring, logging, and alerting systems to track application health, smart contract events, and user activity.

**Acceptance Criteria:**
- [ ] Set up application monitoring (Sentry, LogRocket, etc.)
- [ ] Configure smart contract event monitoring
- [ ] Create alerts for critical failures
- [ ] Set up log aggregation
- [ ] Monitor database performance
- [ ] Track API response times
- [ ] Create status page
- [ ] Set up uptime monitoring

**Technical Notes:**
- Consider using services like Tenderly for contract monitoring
- Set up alerts for unusual activity patterns

---

### Issue #23: Create Comprehensive Documentation and Developer Guides
**Priority:** Low | **Type:** Documentation | **Labels:** `documentation`, `docs`, `onboarding`

**Description:**
Write comprehensive documentation for users, developers, and smart contract auditors.

**Acceptance Criteria:**
- [ ] Create user guide for each pool type
- [ ] Write API documentation
- [ ] Document smart contract architecture
- [ ] Create developer setup guide
- [ ] Write deployment guide
- [ ] Add troubleshooting section
- [ ] Create video tutorials (optional)
- [ ] Translate documentation to multiple languages

**Deliverables:**
- `/docs` directory structure
- User guides
- API documentation
- Developer documentation

---

**Total Issues Created: 23**

### Issue Categories Summary:
- 🔴 **High Priority (6 issues):** Core smart contracts, database setup, event indexing
- 🟡 **Medium Priority (9 issues):** Frontend features, automation, security
- 🟢 **Low Priority (5 issues):** Nice-to-have features, enhancements
- 📝 **Infrastructure (3 issues):** DevOps, monitoring, documentation

These issues are specifically tailored for building Ajosave as a DeFi platform for digitizing ROSCAs, with focus on the three pool types, smart contract security, and Base/Farcaster integration.
