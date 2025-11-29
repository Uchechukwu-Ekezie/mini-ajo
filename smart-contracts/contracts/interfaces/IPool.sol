// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title IPool
 * @notice Interface for all pool types in Ajosave
 * @dev Defines common functionality for Rotational, Target, and Flexible pools
 */
interface IPool {
    /// @notice Pool status enum
    enum PoolStatus {
        Active,
        Completed,
        Cancelled,
        Paused
    }

    /// @notice Member information
    struct Member {
        address memberAddress;
        uint256 totalContributed;
        uint256 totalReceived;
        bool isActive;
        uint256 joinedAt;
    }

    /// @notice Pool configuration
    struct PoolConfig {
        address creator;
        uint256 contributionAmount;
        uint256 penaltyAmount;
        uint256 gracePeriod;
        PoolStatus status;
        uint256 createdAt;
        uint256 totalMembers;
    }

    /// @notice Emitted when a member joins the pool
    event MemberJoined(address indexed member, uint256 timestamp);

    /// @notice Emitted when a member contributes
    event ContributionMade(
        address indexed member,
        uint256 amount,
        uint256 timestamp
    );

    /// @notice Emitted when funds are distributed
    event FundsDistributed(
        address indexed recipient,
        uint256 amount,
        uint256 timestamp
    );

    /// @notice Emitted when a penalty is applied
    event PenaltyApplied(
        address indexed member,
        uint256 amount,
        uint256 timestamp
    );

    /// @notice Get pool configuration
    function getPoolConfig() external view returns (PoolConfig memory);

    /// @notice Get member information
    function getMember(address member) external view returns (Member memory);

    /// @notice Check if address is a member
    function isMember(address member) external view returns (bool);

    /// @notice Get pool balance
    function getPoolBalance() external view returns (uint256);

    /// @notice Get total members count
    function getTotalMembers() external view returns (uint256);
}

