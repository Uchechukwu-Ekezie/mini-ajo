// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../base/PoolBase.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title RotationalPool
 * @notice Implements traditional Ajo/Esusu rotational savings pool
 * @dev Members contribute in turns and receive payouts in rotation order
 */
contract RotationalPool is PoolBase {
    using Address for address payable;

    /// @notice Current rotation index (who's turn it is)
    uint256 public currentRotationIndex;

    /// @notice Number of completed rotations
    uint256 public completedRotations;

    /// @notice Total rotations (number of members)
    uint256 public totalRotations;

    /// @notice Mapping of rotation index to member address
    mapping(uint256 => address) public rotationOrder;

    /// @notice Mapping to track if member has received payout in current rotation
    mapping(address => bool) public hasReceivedCurrentRotation;

    /// @notice Rotation completion event
    event RotationCompleted(
        uint256 rotationIndex,
        address indexed recipient,
        uint256 amount,
        uint256 timestamp
    );

    /**
     * @notice Constructor for RotationalPool
     * @param _creator Address of the pool creator
     * @param _contributionAmount Amount each member should contribute per rotation
     * @param _penaltyAmount Penalty for missed contributions
     * @param _gracePeriod Grace period in seconds before penalties apply
     * @param _members Array of member addresses (order determines rotation)
     */
    constructor(
        address _creator,
        uint256 _contributionAmount,
        uint256 _penaltyAmount,
        uint256 _gracePeriod,
        address[] memory _members
    ) PoolBase(_creator, _contributionAmount, _penaltyAmount, _gracePeriod) {
        require(_members.length > 1, "RotationalPool: Need at least 2 members");

        // Add creator as first member if not in list
        if (_members[0] != _creator) {
            _addMember(_creator);
            rotationOrder[0] = _creator;
            totalRotations = 1;
        }

        // Add all members and set rotation order
        for (uint256 i = 0; i < _members.length; i++) {
            if (!isActiveMember[_members[i]]) {
                _addMember(_members[i]);
            }
            rotationOrder[totalRotations] = _members[i];
            totalRotations++;
        }

        currentRotationIndex = 0;
    }

    /**
     * @notice Contribute to the pool
     * @dev Must send exact contribution amount
     */
    function contribute() external payable nonReentrant whenNotPaused onlyMember {
        require(
            msg.value == poolConfig.contributionAmount,
            "RotationalPool: Incorrect contribution amount"
        );
        require(
            poolConfig.status == PoolStatus.Active,
            "RotationalPool: Pool not active"
        );

        // Update member's contribution tracking
        members[msg.sender].totalContributed += msg.value;
        poolBalance += msg.value;

        emit ContributionMade(msg.sender, msg.value, block.timestamp);

        // Check if current rotation is complete and payout can be made
        _checkAndProcessRotation();
    }

    /**
     * @notice Process payout for current rotation recipient
     * @dev Can be called by anyone once rotation is complete
     */
    function processPayout() external nonReentrant onlyActive {
        _checkAndProcessRotation();
    }

    /**
     * @notice Internal function to check and process rotation
     */
    function _checkAndProcessRotation() internal {
        // Calculate expected pool balance for current rotation
        uint256 expectedBalance = poolConfig.contributionAmount *
            poolConfig.totalMembers;

        // Check if all members have contributed for current rotation
        if (poolBalance >= expectedBalance) {
            address recipient = rotationOrder[currentRotationIndex];

            require(
                !hasReceivedCurrentRotation[recipient],
                "RotationalPool: Already paid this rotation"
            );

            // Distribute payout
            uint256 payoutAmount = poolBalance;
            poolBalance = 0;
            hasReceivedCurrentRotation[recipient] = true;

            members[recipient].totalReceived += payoutAmount;
            payable(recipient).sendValue(payoutAmount);

            emit FundsDistributed(recipient, payoutAmount, block.timestamp);
            emit RotationCompleted(
                currentRotationIndex,
                recipient,
                payoutAmount,
                block.timestamp
            );

            // Move to next rotation
            currentRotationIndex++;
            completedRotations++;

            // Reset flags for next rotation
            if (currentRotationIndex < totalRotations) {
                // Reset all member flags for next rotation
                for (uint256 i = 0; i < memberList.length; i++) {
                    hasReceivedCurrentRotation[memberList[i]] = false;
                }
            } else {
                // All rotations complete
                poolConfig.status = PoolStatus.Completed;
            }
        }
    }

    /**
     * @notice Get current rotation recipient
     * @return Address of member who should receive payout
     */
    function getCurrentRecipient() external view returns (address) {
        if (currentRotationIndex >= totalRotations) {
            return address(0);
        }
        return rotationOrder[currentRotationIndex];
    }

    /**
     * @notice Get rotation status
     * @return currentIndex Current rotation index
     * @return total Total rotations
     * @return completed Completed rotations
     * @return isComplete Whether pool is completed
     */
    function getRotationStatus()
        external
        view
        returns (
            uint256 currentIndex,
            uint256 total,
            uint256 completed,
            bool isComplete
        )
    {
        return (
            currentRotationIndex,
            totalRotations,
            completedRotations,
            poolConfig.status == PoolStatus.Completed
        );
    }
}

