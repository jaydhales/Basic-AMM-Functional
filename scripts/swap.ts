import { ethers } from "hardhat";

const swap = "0x7c0Ea13D006ccBEc644a16a21995a73c472CE48d";

const tokens = [
  "0xF60ED92Fe334a69E71FDB0dC3b7b6bBC0134AA97",
  "0x5AB319218641c626c43E687A2FAACad034C35E23",
];

async function main() {
  const ownerAddr = "0xd8500da651a2e472ad870cdf76b5756f9c113257";
  // const ownerSig = await ethers.getImpersonatedSigner(ownerAddr);
  const [ownerSig] = await ethers.getSigners();
  const contractTokenA = await ethers.getContractAt("IERC20", tokens[0]);
  const contractTokenB = await ethers.getContractAt("IERC20", tokens[1]);

  console.log({
    balanceA: ethers.formatEther(await contractTokenA.balanceOf(ownerAddr)),
    balanceB: ethers.formatEther(await contractTokenB.balanceOf(ownerAddr)),
  });

  const swapContract = await ethers.deployContract("SwapProtocol", tokens);
  await swapContract.waitForDeployment();

  console.log(swapContract.target);

  const liquidityAmt = ethers.parseEther("50");
  const enoughAllawee = ethers.parseEther("20000000000");

  await contractTokenA
    .connect(ownerSig)
    .approve(swapContract.target, enoughAllawee);
  await contractTokenB
    .connect(ownerSig)
    .approve(swapContract.target, enoughAllawee);

  const liquidityTx = await swapContract
    .connect(ownerSig)
    .addLiquidity(liquidityAmt, liquidityAmt);

  await liquidityTx.wait();

  console.log({
    reserve: (await swapContract.getReserve()).map((r) =>
      ethers.formatEther(r)
    ),
  });

  console.log({
    "balanceA before swap": ethers.formatEther(
      await contractTokenA.balanceOf(ownerAddr)
    ),
    "balanceB before swap": ethers.formatEther(
      await contractTokenB.balanceOf(ownerAddr)
    ),
  });

  const amtAtoSwap = ethers.parseEther("2");

  await swapContract.connect(ownerSig).swap(tokens[0], amtAtoSwap);

  console.log({
    "balanceA after swap": ethers.formatEther(
      await contractTokenA.balanceOf(ownerAddr)
    ),
    "balanceB after swap": ethers.formatEther(
      await contractTokenB.balanceOf(ownerAddr)
    ),
  });

  console.log({
    reserveAfterSwap: (await swapContract.getReserve()).map((r) =>
      ethers.formatEther(r)
    ),
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
