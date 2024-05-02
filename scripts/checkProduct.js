const { ethers } = require("hardhat");

const deployed_addresses = require("../ignition/deployments/chain-31337/deployed_addresses.json");
const tagAddr = deployed_addresses["RadixModule#RadixTag"];


const main = async () => {
    // NFC tag operations
    const nfcSK = new ethers.SigningKey("0xf214f2b2cd398c806f84e317254e0f0b801d0643303237d97a22a48e01628897");

    console.log("Getting NFC address...");
    const nfcAddr = ethers.computeAddress(nfcSK.publicKey);
    console.log("NFC address: ", nfcAddr);

    console.log("Authenticating NFC tag...");
    const rnd_nonce = ethers.randomBytes(32);
    console.log("Nonce: ", ethers.hexlify(rnd_nonce));
    const rnd_nonce_hash = ethers.hashMessage(rnd_nonce);
    const signature = nfcSK.sign(rnd_nonce_hash);
    console.log("Signature: ", ethers.hexlify(signature.compactSerialized));

    console.log("Checking signature validity...");
    const recoveredAddr = ethers.verifyMessage(rnd_nonce, signature);
    if (recoveredAddr !== nfcAddr) {
        throw new Error("Invalid signature");
    } else {
        console.log("Signature is valid! NFT tag is authenticated.");
    }

    console.log("Check NFT...");
    const tagContract = await ethers.getContractAt("RadixTag", tagAddr);
    const nftIsPresent = await tagContract.balanceOf(nfcAddr);
    if (!nftIsPresent) {
        throw new Error("NFT not present");
    } else {
        console.log("NFT is present! Product is verified.");
    }
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});