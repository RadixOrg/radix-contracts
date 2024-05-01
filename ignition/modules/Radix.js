const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("RadixModule", (m) => {
    const collectionName = m.getParameter("collectionName", "Example Collection");
    const collectionSymbol = m.getParameter("collectionSymbol", "EXC");
    const producer = m.getParameter("producer", "f39Fd6e51aad88F6F4ce6aB8827279cffFb92266");

    const tag = m.contract("RadixTag", [collectionName, collectionSymbol, producer]);
    const ownership = m.contract("RadixOwnership", [collectionName, collectionSymbol, producer, tag]);

    // call the set ownership function in the tag contract
    m.call(tag, "initialize", [ownership])

    return { tag, ownership };
})