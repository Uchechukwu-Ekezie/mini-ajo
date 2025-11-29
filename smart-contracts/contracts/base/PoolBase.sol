// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../interfaces/IPool.sol";

/**
 * @title PoolBase
 * @notice Base contract for all pool types with common functionality
 * @dev Provides shared features like member management, penalties, and security
 */
abstract contract PoolBase is IPool, ReentrancyGuard, Ownable, Pausable {
    using Address for address payable;

    /// @notice Pool configuration
    PoolConfig public poolConfig;

    /// @notice Mapping of member addresses to Member struct
    mapping(address => Member) public members;

    /// @notice Array of all member addresses
    address[] public memberList;

    /// @notice Mapping to track if address is a member
    mapping(address => bool) public isActiveMember;

    /// @notice Total pool balance
    uint256 public poolBalance;

    /// @notice Grace period for contributions (in seconds)
    uint256 public gracePeriod;

    /// @notice Penalty amount for missed contributions
    uint256 public penaltyAmount;

    /// @notice Modifier to check if caller is a member
    modifier onlyMember() {
        require(isActiveMember[msg.sender], "PoolBase: Not a member");
        _;
    }

    /// @notice Modifier to check if pool is active
    modifier onlyActive() {
        require(
            poolConfig.status == PoolStatus.Active,
            "PoolBase: Pool not active"
        );
        _;
    }

    /**
     * @notice Constructor for PoolBase
     * @param _creator Address of the pool creator
     * @param _contributionAmount Amount each member should contribute
     * @param _penaltyAmount Penalty for missed contributions
     * @param _gracePeriod Grace period in seconds before penalties apply
     */
    constructor(
        address _creator,
        uint256 _contributionAmount,
        uint256 _penaltyAmount,
        uint256 _gracePeriod
    ) Ownable(_creator) {
        require(_creator != address(0), "PoolBase: Invalid creator");
        require(_contributionAmount > 0, "PoolBase: Invalid contribution");

        poolConfig = PoolConfig({
            creator: _creator,
            contributionAmount: _contributionAmount,
            penaltyAmount: _penaltyAmount,
            gracePeriod: _gracePeriod,
            status: PoolStatus.Active,
            createdAt: block.timestamp,
            totalMembers: 0
        });

        gracePeriod = _gracePeriod;
        penaltyAmount = _penaltyAmount;
    }

    /**
     * @notice Get pool configuration
     * @return PoolConfig struct
     */
    function getPoolConfig() external view override returns (PoolConfig memory) {
        return poolConfig;
    }

    /**
     * @notice Get member information
     * @param member Address of the member
     * @return Member struct
     */
    function getMember(address member)
        external
        view
        override
        returns (Member memory)
    {
        return members[member];
    }

    /**
     * @notice Check if address is a member
     * @param member Address to check
     * @return True if member, false otherwise
     */
    function isMember(address member) external view override returns (bool) {
        return isActiveMember[member];
    }

    /**
     * @notice Get pool balance
     * @return Current pool balance
     */
    function getPoolBalance() external view override returns (uint256) {
        return poolBalance;
    }

    /**
     * @notice Get total members count
     * @return Number of active members
     */
    function getTotalMembers() external view override returns (uint256) {
        return poolConfig.totalMembers;
    }

    /**
     * @notice Add a member to the pool (internal function)
     * @param newMember Address of the new member
     */
    function _addMember(address newMember) internal {
        require(newMember != address(0), "PoolBase: Invalid member");
        require(!isActiveMember[newMember], "PoolBase: Already a member");
        require(
            poolConfig.status == PoolStatus.Active,
            "PoolBase: Pool not accepting members"
        );

        members[newMember] = Member({
            memberAddress: newMember,
            totalContributed: 0,
            totalReceived: 0,
            isActive: true,
            joinedAt: block.timestamp
        });

        memberList.push(newMember);
        isActiveMember[newMember] = true;
        poolConfig.totalMembers++;

        emit MemberJoined(newMember, block.timestamp);
    }

    /**
     * @notice Apply penalty to a member (internal function)
     * @param member Address of the member to penalize
     */
    function _applyPenalty(address member) internal {
        require(isActiveMember[member], "PoolBase: Not a member");
        require(penaltyAmount > 0, "PoolBase: No penalty configured");

        // Deduct penalty from member's contribution
        if (members[member].totalContributed >= penaltyAmount) {
            members[member].totalContributed -= penaltyAmount;
            poolBalance -= penaltyAmount;
        }

        emit PenaltyApplied(member, penaltyAmount, block.timestamp);
    }

    /**
     * @notice Pause the pool (only owner)
     */
    function pause() external onlyOwner {
        _pause();
        poolConfig.status = PoolStatus.Paused;
    }

    /**
     * @notice Unpause the pool (only owner)
     */
    function unpause() external onlyOwner {
        _unpause();
        poolConfig.status = PoolStatus.Active;
    }

    /**
     * @notice Cancel the pool (only owner)
     */
    function cancelPool() external onlyOwner {
        require(
            poolConfig.status == PoolStatus.Active ||
                poolConfig.status == PoolStatus.Paused,
            "PoolBase: Cannot cancel"
        );
        poolConfig.status = PoolStatus.Cancelled;
    }

    /**
     * @notice Get all member addresses
     * @return Array of member addresses
     */
    function getAllMembers() external view returns (address[] memory) {
        return memberList;
    }

    /**
     * @notice Receive function to accept ETH
     */
    receive() external payable {
        poolBalance += msg.value;
    }
}

