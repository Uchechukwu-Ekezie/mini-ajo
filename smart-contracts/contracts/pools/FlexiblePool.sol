// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../base/PoolBase.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title FlexiblePool
 * @notice Implements flexible savings pool with yield strategies
 * @dev Members can deposit/withdraw anytime, idle funds can earn yield
 */
contract FlexiblePool is PoolBase {
    using Address for address payable;

    /// @notice Minimum deposit amount
    uint256 public minDeposit;

    /// @notice Minimum withdrawal amount
    uint256 public minWithdrawal;

    /// @notice Yield rate per second (as a percentage, e.g., 1e16 = 1% per second scaled)
    uint256 public yieldRate;

    /// @notice Last yield calculation timestamp
    uint256 public lastYieldTimestamp;

    /// @notice Total yield earned by all members
    uint256 public totalYieldEarned;

    /// @notice Event emitted when yield is distributed
    event YieldDistributed(uint256 amount, uint256 timestamp);

    /**
     * @notice Constructor for FlexiblePool
     * @param _creator Address of the pool creator
     * @param _minDeposit Minimum deposit amount
     * @param _penaltyAmount Penalty for early withdrawal (if any)
     * @param _gracePeriod Grace period in seconds
     * @param _yieldRate Annual yield rate (e.g., 500 = 5%)
     */
    constructor(
        address _creator,
        uint256 _minDeposit,
        uint256 _penaltyAmount,
        uint256 _gracePeriod,
        uint256 _yieldRate
    ) PoolBase(_creator, _minDeposit, _penaltyAmount, _gracePeriod) {
        require(_minDeposit > 0, "FlexiblePool: Invalid min deposit");
        minDeposit = _minDeposit;
        minWithdrawal = _minDeposit / 10; // 10% of min deposit
        yieldRate = _yieldRate;
        lastYieldTimestamp = block.timestamp;

        // Add creator as first member
        _addMember(_creator);
    }

    /**
     * @notice Join the pool with initial deposit
     */
    function joinPool() external payable {
        require(
            poolConfig.status == PoolStatus.Active,
            "FlexiblePool: Pool not accepting members"
        );
        require(!isActiveMember[msg.sender], "FlexiblePool: Already a member");
        require(msg.value >= minDeposit, "FlexiblePool: Below minimum deposit");

        _addMember(msg.sender);
        members[msg.sender].totalContributed += msg.value;
        poolBalance += msg.value;

        emit ContributionMade(msg.sender, msg.value, block.timestamp);
    }

    /**
     * @notice Deposit funds to the pool
     */
    function deposit() external payable nonReentrant whenNotPaused onlyMember {
        require(
            poolConfig.status == PoolStatus.Active,
            "FlexiblePool: Pool not active"
        );
        require(msg.value >= minDeposit, "FlexiblePool: Below minimum deposit");

        _calculateAndDistributeYield();

        members[msg.sender].totalContributed += msg.value;
        poolBalance += msg.value;

        emit ContributionMade(msg.sender, msg.value, block.timestamp);
    }

    /**
     * @notice Withdraw funds from the pool
     * @param amount Amount to withdraw
     */
    function withdraw(uint256 amount) external nonReentrant whenNotPaused onlyMember {
        require(
            poolConfig.status == PoolStatus.Active,
            "FlexiblePool: Pool not active"
        );
        require(amount >= minWithdrawal, "FlexiblePool: Below minimum withdrawal");

        _calculateAndDistributeYield();

        require(
            members[msg.sender].totalContributed >= amount,
            "FlexiblePool: Insufficient balance"
        );
        require(poolBalance >= amount, "FlexiblePool: Pool insufficient funds");

        members[msg.sender].totalContributed -= amount;
        poolBalance -= amount;

        payable(msg.sender).sendValue(amount);

        emit FundsDistributed(msg.sender, amount, block.timestamp);
    }

    /**
     * @notice Calculate and distribute yield based on time elapsed
     */
    function _calculateAndDistributeYield() internal {
        if (poolBalance == 0 || poolConfig.totalMembers == 0) {
            lastYieldTimestamp = block.timestamp;
            return;
        }

        uint256 timeElapsed = block.timestamp - lastYieldTimestamp;
        if (timeElapsed == 0) return;

        // Calculate yield: (balance * rate * time) / (100 * 365 days in seconds)
        // yieldRate is annual percentage (e.g., 500 = 5%)
        uint256 yieldAmount = (poolBalance * yieldRate * timeElapsed) /
            (10000 * 365 days);

        if (yieldAmount > 0) {
            // Distribute yield proportionally based on contributions
            uint256 totalContributed = 0;
            for (uint256 i = 0; i < memberList.length; i++) {
                if (members[memberList[i]].isActive) {
                    totalContributed += members[memberList[i]].totalContributed;
                }
            }

            if (totalContributed > 0) {
                for (uint256 i = 0; i < memberList.length; i++) {
                    address member = memberList[i];
                    if (members[member].isActive && members[member].totalContributed > 0) {
                        uint256 memberYield = (yieldAmount *
                            members[member].totalContributed) / totalContributed;
                        members[member].totalReceived += memberYield;
                        members[member].totalContributed += memberYield; // Yield adds to balance
                    }
                }

                poolBalance += yieldAmount;
                totalYieldEarned += yieldAmount;
                emit YieldDistributed(yieldAmount, block.timestamp);
            }
        }

        lastYieldTimestamp = block.timestamp;
    }

    /**
     * @notice Manually trigger yield calculation
     * @dev Can be called by anyone to update yield
     */
    function calculateYield() external {
        _calculateAndDistributeYield();
    }

    /**
     * @notice Get member's current balance including accrued yield
     * @param member Address of the member
     * @return Current balance
     */
    function getMemberBalance(address member) external view returns (uint256) {
        return members[member].totalContributed;
    }

    /**
     * @notice Get total yield information
     * @return totalYield Total yield earned
     * @return rate Current yield rate
     */
    function getYieldInfo() external view returns (uint256 totalYield, uint256 rate) {
        return (totalYieldEarned, yieldRate);
    }
}

