import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat";
import { YourToken } from "../typechain-types";

const deployVendor: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const yourToken = (await ethers.getContract("YourToken", deployer)) as YourToken;

  const vendorDeployment = await deploy("Vendor", {
    from: deployer,
    args: [yourToken.target],
    log: true,
    autoMine: true,
  });

  await yourToken.transfer(vendorDeployment.address, ethers.parseEther("500"));

  console.log("✅ Vendor deployed at:", vendorDeployment.address);
  console.log("   Vendor token balance:", (await yourToken.balanceOf(vendorDeployment.address)).toString());
};

export default deployVendor;
deployVendor.tags = ["Vendor"];
