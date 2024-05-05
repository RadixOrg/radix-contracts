const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { ethers } = require("hardhat");

const { expect } = require("chai");

describe("Radix", function () {
    async function deployRadixFixture() {
        const collectionName = "Example Collection";
        const collectionSymbol = "EXC";
        const [producer, product, user] = (await ethers.getSigners());

        const RadixTag = await ethers.getContractFactory("RadixTag");
        const tag = await RadixTag.deploy(collectionName, collectionSymbol, producer.address);

        const RadixOwnership = await ethers.getContractFactory("RadixOwnership");
        let ownership = await RadixOwnership.deploy(collectionName, collectionSymbol, producer.address, tag.target);
        ownership = ownership.connect(user);

        const setOwnershipTx = await tag.setOwnershipContract(ownership.target);
        setOwnershipTx.wait();

        return { tag, ownership, producer, product, user };

    }

    it("Should create a product and assign it to the correct address", async function () {
        const { tag, product } = await loadFixture(deployRadixFixture);

        const seq = ethers.getBytes(ethers.hashMessage(ethers.getBytes("0x00")));
        const sig = ethers.Signature.from(await product.signMessage(seq));
        const sigHash = ethers.keccak256(ethers.keccak256(sig.compactSerialized));

        const createProductTx = await tag.createProduct(product.address, "Example Product", sigHash);
        await createProductTx.wait();

        const nftIsPresent = await tag.balanceOf(product.address);
        expect(nftIsPresent).to.equal(1);
    });

    it("Sould claim the Ownership of a product", async function () {
        const { tag, ownership, product, user } = await loadFixture(deployRadixFixture);

        const seq = ethers.getBytes(ethers.hashMessage(ethers.getBytes("0x00")));
        const sig = ethers.Signature.from(await product.signMessage(seq));
        const sigHash = ethers.keccak256(ethers.keccak256(sig.compactSerialized));

        const createProductTx = await tag.createProduct(product.address, "Example Product", sigHash);
        await createProductTx.wait();

        const claimOwnershipTx = await ownership.claimOwnership(0, ethers.keccak256(sig.compactSerialized));
        claimOwnershipTx.wait();

        const owner = await ownership.ownerOf(0);
        expect(owner).to.equal(user.address);
    });
});