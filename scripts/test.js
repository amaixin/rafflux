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
  const rafStorage = await hre.ethers.getContractFactory("RaffluxStorage");
  const rafStoreDeployed = await rafStorage.deploy();
  const rafContract = await hre.ethers.getContractFactory("Rafflux");
  const rafDeployed = await rafContract.deploy();

  await rafDeployed.deployed();
  console.log("Deployed Contract Address :" + (await rafDeployed.address));
  console.log(
    "Rafflux Store Contract Address :" + (await rafStoreDeployed.address)
  );

  const contractbal = await hre.ethers.provider.getBalance(rafDeployed.address);

  console.log("Contract Balance: ", hre.ethers.utils.formatEther(contractbal));

  var rafSigner = await rafDeployed.connect(randSigner);
  let transfrItem = await rafSigner.createRaffle(
    1,
    1,
    nftContractAddress,
    hre.ethers.utils.parseEther("1"),
    { value: hre.ethers.utils.parseEther("1") }
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
