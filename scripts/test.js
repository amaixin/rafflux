const Lock = await hre.ethers.getContractFactory("Rafflux");
const lock = await Lock.deploy();

await lock.deployed();
