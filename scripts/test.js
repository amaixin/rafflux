async function startRafflux() {
  const [owner, randSigner] = await hre.ethers.getSigners();
  console.log("Owner Address: ", owner.address);
  console.log("RandomSigner Address: ", randSigner.address);

  //Deploy ERC1155 contract
  const erc1155Con = await hre.ethers.getContractFactory("MaaketErc1155");
  const erc1155Deployed = await erc1155Con.deploy();

  //Maaket ERC11155 Contract Address
  const erc1155MaaketAddr = await erc1155Deployed.address;

  const initNft = await erc1155Deployed
    .connect(randSigner)
    .createNft({ value: hre.ethers.utils.parseEther("0.02") });

  await initNft.wait();

  console.log("Erc1155 Contract: ", erc1155MaaketAddr);

  console.log(
    "Balance of Deployer (aka token owner): ",
    hre.ethers.BigNumber.isBigNumber(
      await erc1155Deployed.balanceOf(randSigner.address, 0)
    ),
    await erc1155Deployed.balanceOf(randSigner.address, 0),
    " It is, but converted to a number, which is: ",
    hre.ethers.BigNumber.from(
      await erc1155Deployed.balanceOf(randSigner.address, 0)
    ).toNumber()
  );

  console.log(
    "Balance of ERC1155 Maaket contract address: ",
    hre.ethers.BigNumber.from(
      await erc1155Deployed.balanceOf(erc1155MaaketAddr, 0)
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

  //approve operator address for transfer for ERC721 Maaket Contract
  await maaketDeployed
    .connect(randSigner)
    .setApprovalForAll(rafDeployed.address, true);

  //approve operator address for transfer for ERC1155 Maaket Contract
  await erc1155Deployed
    .connect(randSigner)
    .setApprovalForAll(rafDeployed.address, true);

  //randsigner transfer token from origin erc721 maaket contract to rafflux
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

  //get balance of raffle contract erc721 maaket
  console.log(
    "Bal ERC721 NFTs of Rafflux Contract: ",
    hre.ethers.BigNumber.from(
      await maaketDeployed.balanceOf(rafDeployed.address)
    ).toNumber()
  );

  //randsigner transfer token from origin erc1155 maaket contract to rafflux
  var crRaffle2 = await rafDeployed
    .connect(randSigner)
    .createRaffle(
      1,
      0,
      erc1155MaaketAddr,
      hre.ethers.utils.parseEther("0.02"),
      { value: hre.ethers.utils.parseEther("0.02") }
    );
  console.log("2nd Ticket Created by: ", crRaffle2.from);

  //get balance of raffle contract ERC1155 Maaket
  console.log(
    "Bal ERC1155 NFTs of Rafflux Contract: ",
    hre.ethers.BigNumber.from(
      await erc1155Deployed.balanceOf(rafDeployed.address, 0)
    ).toNumber()
  );

  //check user NFT balances
  console.log(
    "New Balance of Deployer (aka token owner): ",
    hre.ethers.BigNumber.from(
      await erc1155Deployed.balanceOf(randSigner.address, 0)
    ).toNumber()
  );

  //Return Raffle Items
  const getStoredItemsPending = await rafDeployed.returnPendingRaffleItem(0);
  console.log(
    "Get specific raffle item by ID - ID: ",
    hre.ethers.BigNumber.from(getStoredItemsPending.id).toNumber()
  );
  console.log("Address: ", getStoredItemsPending.owner);

  //Get Date
  const eDate = hre.ethers.BigNumber.from(
    getStoredItemsPending.date
  ).toNumber();
  const getDate = new Date(eDate * 1000);
  console.log("Date: ", getDate.toLocaleString());
  console.log("Proposal State: ", getStoredItemsPending.state);

  //Return all raffle items
  const getAllPendingRaffItems =
    await rafDeployed.returnAllPendingRaffleItems();
  console.log(
    "All Pending Raffle Items: ",
    getAllPendingRaffItems,
    "Items length: ",
    getAllPendingRaffItems.length
  );

  //approve items
  const approveItems = await rafDeployed.approveRaffleItems(0);
  await approveItems.wait();

  //return all pending items again
  const getAllPendingRaffItems2 =
    await rafDeployed.returnAllPendingRaffleItems();
  console.log(
    "New Pending Raffle Items: ",
    getAllPendingRaffItems2,
    "Items length: ",
    getAllPendingRaffItems2.length
  );

  //reject items on pending
  const rejPendingitems = await rafDeployed.rejectPendingRaffleItems(0, {
    value: hre.ethers.utils.parseEther("0.02"),
  });
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
