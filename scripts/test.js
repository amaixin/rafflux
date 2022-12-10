async function startRafflux() {
  //deploy and create NFT from NFT contract
  const [owner, randSigner] = await hre.ethers.getSigners();
  const MyContract = await hre.ethers.getContractFactory("Maaket");
  const deployedContract = await MyContract.deploy();
  await deployedContract.deployed();

  const nftContractAddress = await deployedContract.address;
  console.log("NFT Contract Address :" + nftContractAddress);

  //Create NFT
  var cNft = await deployedContract.connect(randSigner);

  await cNft.createNft("testingurl", hre.ethers.utils.parseEther("0.02"), {
    value: hre.ethers.utils.parseEther("0.02"),
  });

  //Deploy Rafflux contracts
  const rafContract = await hre.ethers.getContractFactory("Rafflux");
  const rafDeployed = await rafContract.deploy();
  await rafDeployed.deployed();
  console.log("Deployed Contract Address :" + (await rafDeployed.address));
  console.log("Owner Address: ", owner.address);

  await deployedContract
    .connect(randSigner)
    .setApprovalForAll(owner.address, true);

  var rafSigner = await rafDeployed.connect(owner);
  let transfrItem = await rafSigner.createRaffle(
    0,
    1,
    nftContractAddress,
    hre.ethers.utils.parseEther("0.02"),
    { value: hre.ethers.utils.parseEther("0.02") }
  );
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
