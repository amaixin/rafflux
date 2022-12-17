async function startRafflux() {
  const [owner, randSigner] = await hre.ethers.getSigners();
  console.log("Owner Address: ", owner.address);
  console.log("RandomSigner Address: ", randSigner.address);

  //Deploy ERC1155 contract
  const erc1155Con = await hre.ethers.getContractFactory("MaaketErc1155");
  const erc1155Deployed = await erc1155Con.deploy();
  const initNft = await erc1155Deployed.createNft();

  await initNft.wait();
  console.log("Erc1155 Contract: ", await erc1155Deployed.address);
  console.log(
    "Balance of Deployer: ",
    hre.ethers.BigNumber.isBigNumber(
      await erc1155Deployed.balanceOf(owner.address, 0)
    ),
    await erc1155Deployed.balanceOf(owner.address, 0),
    " It is, but converted to a number, which is: ",
    hre.ethers.BigNumber.from(
      await erc1155Deployed.balanceOf(owner.address, 0)
    ).toNumber()
  );

  //Deploy Rafflux contracts
  const rafContract = await hre.ethers.getContractFactory("Rafflux");
  const rafDeployed = await rafContract.deploy();
  await rafDeployed.deployed();
  console.log("Rafflux Contract Address: " + (await rafDeployed.address));

  //deploy and create NFT from NFT contract
  const maaketContract = await hre.ethers.getContractFactory("Maaket");
  const maaketDeployed = await maaketContract.deploy();
  await maaketDeployed.deployed();
  const nftContractAddress = await maaketDeployed.address;
  console.log("NFT Contract Address: " + nftContractAddress);

  //Create NFT
  var cNft = await maaketDeployed.connect(randSigner);
  var crNFT = await cNft.createNft(
    "testingurl",
    hre.ethers.utils.parseEther("0.02"),
    {
      value: hre.ethers.utils.parseEther("0.02"),
    }
  );

  await crNFT.wait();

  const operatorApprove = await maaketDeployed
    .connect(randSigner)
    .setApprovalForAll(rafDeployed.address, true);

  await operatorApprove.wait();

  var crRaffle = await rafDeployed
    .connect(randSigner)
    .createRaffle(
      0,
      1,
      nftContractAddress,
      hre.ethers.utils.parseEther("0.02"),
      { value: hre.ethers.utils.parseEther("0.02") }
    );
  console.log("Ticket Created by: ", crRaffle.from);
}

async function runDeployer() {
  try {
    await startRafflux();
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

runDeployer();
