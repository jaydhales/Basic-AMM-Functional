import { ethers } from "hardhat";

async function main() {
  const tokenContractA = await ethers.deployContract("Token", [
    "Ryuochi",
    "CHI",
  ]);
  const tokenContractB = await ethers.deployContract("Token", [
    "Ryuoku",
    "OKU",
  ]);

  await tokenContractA.waitForDeployment();
  await tokenContractB.waitForDeployment();

  console.log({
    tokenContractA: tokenContractA.target,
    tokenContractB: tokenContractB.target,
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
