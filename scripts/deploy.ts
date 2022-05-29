import { ethers } from "hardhat";

async function main() {
  const provider = ethers.provider;
  const deployerWallet = new ethers.Wallet(
    // @ts-expect-error
    process.env.AURORA_PRIVATE_KEY,
    provider
  );

  console.log("Deploying contracts with the account:", deployerWallet.address);

  console.log(
    "Account balance:",
    (await deployerWallet.getBalance()).toString()
  );

  // Deploying
  const GlassHub = await ethers.getContractFactory("GlassHub");
  const glassHub = await GlassHub.deploy();

  await glassHub.deployed();

  console.log("Deployed glassHub to addr: ", glassHub.address);

  const GlassProfileNFT = await ethers.getContractFactory("GlassProfileNFT");
  const glassProfileNFT = await GlassProfileNFT.connect(deployerWallet).deploy(
    glassHub.address
  );

  await glassProfileNFT.deployed();

  console.log("Deployed glassProfileNFT to addr: ", glassProfileNFT.address);

  const GlassPublicationNFT = await ethers.getContractFactory(
    "GlassPublicationNFT"
  );
  const glassPublicationNFT = await GlassPublicationNFT.connect(
    deployerWallet
  ).deploy(glassHub.address);

  await glassPublicationNFT.deployed();

  console.log(
    "Deployed glassPublicationNFT to addr: ",
    glassProfileNFT.address
  );

  await glassHub.setModules(
    glassProfileNFT.address,
    glassPublicationNFT.address
  );

  console.log("Glasshub modules are set, all done!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
