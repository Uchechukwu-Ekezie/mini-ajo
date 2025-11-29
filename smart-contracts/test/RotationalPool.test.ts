import { expect } from "chai";
import { ethers } from "hardhat";
import { RotationalPool } from "../typechain-types";

describe("RotationalPool", function () {
  let rotationalPool: RotationalPool;
  let owner: any;
  let member1: any;
  let member2: any;
  let member3: any;
  const contributionAmount = ethers.parseEther("0.01");
  const penaltyAmount = ethers.parseEther("0.001");

  beforeEach(async function () {
    [owner, member1, member2, member3] = await ethers.getSigners();

    const RotationalPoolFactory = await ethers.getContractFactory("RotationalPool");
    const members = [owner.address, member1.address, member2.address, member3.address];
    
    rotationalPool = await RotationalPoolFactory.deploy(
      owner.address,
      contributionAmount,
      penaltyAmount,
      7 * 24 * 60 * 60, // 7 days grace period
      members
    );

    await rotationalPool.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set the right creator", async function () {
      const config = await rotationalPool.getPoolConfig();
      expect(config.creator).to.equal(owner.address);
    });

    it("Should have correct contribution amount", async function () {
      const config = await rotationalPool.getPoolConfig();
      expect(config.contributionAmount).to.equal(contributionAmount);
    });

    it("Should have all members added", async function () {
      const totalMembers = await rotationalPool.getTotalMembers();
      expect(totalMembers).to.equal(4);
    });
  });

  describe("Contributions", function () {
    it("Should allow members to contribute", async function () {
      await expect(
        rotationalPool.connect(member1).contribute({ value: contributionAmount })
      ).to.emit(rotationalPool, "ContributionMade");
    });

    it("Should reject incorrect contribution amount", async function () {
      await expect(
        rotationalPool.connect(member1).contribute({ value: ethers.parseEther("0.005") })
      ).to.be.revertedWith("RotationalPool: Incorrect contribution amount");
    });

    it("Should reject non-member contributions", async function () {
      const [nonMember] = await ethers.getSigners();
      await expect(
        rotationalPool.connect(nonMember).contribute({ value: contributionAmount })
      ).to.be.revertedWith("PoolBase: Not a member");
    });
  });

  describe("Rotation", function () {
    it("Should process payout when rotation is complete", async function () {
      // All 4 members contribute
      await rotationalPool.connect(owner).contribute({ value: contributionAmount });
      await rotationalPool.connect(member1).contribute({ value: contributionAmount });
      await rotationalPool.connect(member2).contribute({ value: contributionAmount });
      
      const balanceBefore = await ethers.provider.getBalance(member3.address);
      await rotationalPool.connect(member3).contribute({ value: contributionAmount });
      
      // Check that member3 (first in rotation) received payout
      const balanceAfter = await ethers.provider.getBalance(member3.address);
      // Should have received ~0.04 ETH (all contributions)
      expect(balanceAfter).to.be.gt(balanceBefore);
    });
  });
});

