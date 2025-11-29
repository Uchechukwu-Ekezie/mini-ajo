import { ethers } from "hardhat";
import * as dotenv from "dotenv";

dotenv.config();

async function main() {
  const [deployer] = await ethers.getSigners();
  
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await ethers.provider.getBalance(deployer.address)).toString());

  // Deploy RotationalPool example
  const RotationalPool = await ethers.getContractFactory("RotationalPool");
  console.log("\nDeploying RotationalPool...");
  
  // Example parameters - adjust as needed
  const creator = deployer.address;
  const contributionAmount = ethers.parseEther("0.01"); // 0.01 ETH
  const penaltyAmount = ethers.parseEther("0.001"); // 0.001 ETH penalty
  const gracePeriod = 7 * 24 * 60 * 60; // 7 days
  const members = [deployer.address]; // Add more members as needed
  
  const rotationalPool = await RotationalPool.deploy(
    creator,
    contributionAmount,
    penaltyAmount,
    gracePeriod,
    members
  );
  
  await rotationalPool.waitForDeployment();
  console.log("RotationalPool deployed to:", await rotationalPool.getAddress());

  // Deploy TargetPool example
  const TargetPool = await ethers.getContractFactory("TargetPool");
  console.log("\nDeploying TargetPool...");
  
  const targetAmount = ethers.parseEther("1.0"); // 1 ETH target
  const deadline = 0; // No deadline (0 = no deadline)
  const distributionMethod = 0; // 0 = equal split, 1 = proportional
  
  const targetPool = await TargetPool.deploy(
    creator,
    contributionAmount,
    penaltyAmount,
    gracePeriod,
    targetAmount,
    deadline,
    distributionMethod
  );
  
  await targetPool.waitForDeployment();
  console.log("TargetPool deployed to:", await targetPool.getAddress());

  // Deploy FlexiblePool example
  const FlexiblePool = await ethers.getContractFactory("FlexiblePool");
  console.log("\nDeploying FlexiblePool...");
  
  const minDeposit = ethers.parseEther("0.01");
  const yieldRate = 500; // 5% annual yield
  
  const flexiblePool = await FlexiblePool.deploy(
    creator,
    minDeposit,
    penaltyAmount,
    gracePeriod,
    yieldRate
  );
  
  await flexiblePool.waitForDeployment();
  console.log("FlexiblePool deployed to:", await flexiblePool.getAddress());

  console.log("\n=== Deployment Summary ===");
  console.log("RotationalPool:", await rotationalPool.getAddress());
  console.log("TargetPool:", await targetPool.getAddress());
  console.log("FlexiblePool:", await flexiblePool.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

