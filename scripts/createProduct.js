const { ethers } = require("hardhat");

const deployed_addresses = require("../ignition/deployments/chain-31337/deployed_addresses.json");
const tagAddr = deployed_addresses["RadixModule#RadixTag"];

const main = async () => {

    // NFC tag operations
    const nfcSK = new ethers.SigningKey("0xf214f2b2cd398c806f84e317254e0f0b801d0643303237d97a22a48e01628897");
    const nfcAddr = ethers.computeAddress(nfcSK.publicKey);
    const seq = ethers.getBytes("0x0000000000000000000000000000000000000000000000000000000000000000");
    const sig = ethers.getBytes(nfcSK.sign(seq).compactSerialized);
    const sigHash = ethers.keccak256(sig);
    // console.log(sigHash)

    // Create a new product
    const tagContract = await ethers.getContractAt("RadixTag", tagAddr);
    console.log("Creating product...");
    const createProductTx = await tagContract.createProduct(nfcAddr, "Example Product", sigHash);
    await createProductTx.wait();
    console.log("Product created!");
};

main().catch((error) => {
    console.error(error);
    process.exit(1);
}); 