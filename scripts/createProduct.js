const { ethers } = require("hardhat");

const deployed_addresses = require("../ignition/deployments/chain-31337/deployed_addresses.json");
const tagAddr = deployed_addresses["RadixModule#RadixTag"];

const main = async () => {

    // NFC tag operations
    const nfcSK = new ethers.SigningKey("0xf214f2b2cd398c806f84e317254e0f0b801d0643303237d97a22a48e01628897");

    console.log("Getting NFC address...");
    const nfcAddr = ethers.computeAddress(nfcSK.publicKey);
    console.log("NFC address: ", nfcAddr);

    console.log("Signing test sequence...");
    const seq = ethers.getBytes("0x00");
    const seqHash = ethers.hashMessage(seq);
    const Sig = nfcSK.sign(seqHash);
    const sig = ethers.keccak256(Sig.compactSerialized);
    console.log("Signature: ", sig);

    console.log("Checking signature validity...");
    const signerAddr = ethers.verifyMessage(seq, Sig);
    if (signerAddr !== nfcAddr) {
        throw new Error("Invalid signature");
    } else {
        console.log("Signature is valid!");
    }

    console.log("Hashing signature...");
    const sigHash = ethers.keccak256(sig);
    console.log("Signature hash: ", sigHash);

    // Create a new product
    const tagContract = await ethers.getContractAt("RadixTag", tagAddr);
    console.log("Creating product NFT...");
    const createProductTx = await tagContract.createProduct(nfcAddr, "Example Product", sigHash);
    await createProductTx.wait();
    console.log("Product created!");
};

main().catch((error) => {
    console.error(error);
    process.exit(1);
}); 