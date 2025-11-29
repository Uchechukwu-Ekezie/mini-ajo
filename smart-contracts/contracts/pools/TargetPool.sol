// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../base/PoolBase.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title TargetPool
 * @notice Implements goal-based savings pool that locks funds until target or deadline
 * @dev Members contribute until goal is reached or deadline passes
 */
contract TargetPool is PoolBase {
    using Address for address payable;

    /// @notice Target amount to reach
    uint256 public targetAmount;

    /// @notice Deadline timestamp (unix timestamp)
    uint256 public deadline;

    /// @notice Distribution method: 0 = equal split, 1 = proportional to contribution
    uint256 public distributionMethod;

    /// @notice Whether the goal has been reached
    bool public goalReached;

    /// @notice Event emitted when goal is reached
    event GoalReached(uint256 amount, uint256 timestamp);

    /// @notice Event emitted when deadline is reached
    event DeadlineReached(uint256 timestamp);

    /**
     * @notice Constructor for TargetPool
     * @param _creator Address of the pool creator
     * @param _contributionAmount Minimum contribution amount per member
     * @param _penaltyAmount Penalty for missed contributions (if applicable)
     * @param _gracePeriod Grace period in seconds
     * @param _targetAmount Target amount to reach
     * @param _deadline Deadline timestamp (0 for no deadline)
     * @param _distributionMethod 0 for equal split, 1 for proportional
     */
    constructor(
        address _creator,
        uint256 _contributionAmount,
        uint256 _penaltyAmount,
        uint256 _gracePeriod,
        uint256 _targetAmount,
        uint256 _deadline,
        uint256 _distributionMethod
    ) PoolBase(_creator, _contributionAmount, _penaltyAmount, _gracePeriod) {
        require(_targetAmount > 0, "TargetPool: Target must be greater than 0");
        require(
            _deadline == 0 || _deadline > block.timestamp,
            "TargetPool: Invalid deadline"
        );
        require(
            _distributionMethod <= 1,
            "TargetPool: Invalid distribution method"
        );

        targetAmount = _targetAmount;
        deadline = _deadline;
        distributionMethod = _distributionMethod;

        // Add creator as first member
        _addMember(_creator);
    }

    /**
     * @notice Join the pool
     */
    function joinPool() external {
        require(
            poolConfig.status == PoolStatus.Active,
            "TargetPool: Pool not accepting members"
        );
        require(!isActiveMember[msg.sender], "TargetPool: Already a member");
        _addMember(msg.sender);
    }

    /**
     * @notice Contribute to the pool
     * @dev Must send at least minimum contribution amount
     */
    function contribute() external payable nonReentrant whenNotPaused onlyActive {
        require(
            msg.value >= poolConfig.contributionAmount,
            "TargetPool: Contribution below minimum"
        );
        require(!goalReached, "TargetPool: Goal already reached");

        members[msg.sender].totalContributed += msg.value;
        poolBalance += msg.value;

        emit ContributionMade(msg.sender, msg.value, block.timestamp);

        // Check if goal is reached
        if (poolBalance >= targetAmount) {
            goalReached = true;
            poolConfig.status = PoolStatus.Completed;
            emit GoalReached(poolBalance, block.timestamp);
            _distributeFunds();
        }
    }

    /**
     * @notice Check deadline and distribute if reached
     * @dev Can be called by anyone once deadline passes
     */
    function checkDeadline() external {
        require(
            deadline > 0 && block.timestamp >= deadline,
            "TargetPool: Deadline not reached"
        );
        require(
            poolConfig.status == PoolStatus.Active,
            "TargetPool: Pool not active"
        );
        require(!goalReached, "TargetPool: Goal already reached");

        poolConfig.status = PoolStatus.Completed;
        emit DeadlineReached(block.timestamp);
        _distributeFunds();
    }

    /**
     * @notice Distribute funds based on distribution method
     */
    function _distributeFunds() internal {
        require(
            poolConfig.status == PoolStatus.Completed,
            "TargetPool: Pool not completed"
        );

        uint256 totalToDistribute = poolBalance;
        poolBalance = 0;

        if (distributionMethod == 0) {
            // Equal split
            uint256 perMember = totalToDistribute / poolConfig.totalMembers;
            uint256 remainder = totalToDistribute %
                poolConfig.totalMembers;

            for (uint256 i = 0; i < memberList.length; i++) {
                address member = memberList[i];
                if (members[member].isActive) {
                    uint256 amount = perMember + (i < remainder ? 1 : 0);
                    members[member].totalReceived += amount;
                    payable(member).sendValue(amount);
                    emit FundsDistributed(member, amount, block.timestamp);
                }
            }
        } else {
            // Proportional to contribution
            uint256 totalContributed = 0;
            for (uint256 i = 0; i < memberList.length; i++) {
                if (members[memberList[i]].isActive) {
                    totalContributed += members[memberList[i]].totalContributed;
                }
            }

            for (uint256 i = 0; i < memberList.length; i++) {
                address member = memberList[i];
                if (members[member].isActive) {
                    uint256 amount = (totalToDistribute *
                        members[member].totalContributed) / totalContributed;
                    members[member].totalReceived += amount;
                    payable(member).sendValue(amount);
                    emit FundsDistributed(member, amount, block.timestamp);
                }
            }
        }
    }

    /**
     * @notice Get pool progress
     * @return current Current balance
     * @return target Target amount
     * @return percentage Progress percentage
     */
    function getProgress()
        external
        view
        returns (
            uint256 current,
            uint256 target,
            uint256 percentage
        )
    {
        percentage = (poolBalance * 100) / targetAmount;
        if (percentage > 100) percentage = 100;
        return (poolBalance, targetAmount, percentage);
    }
}

