// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RadixTag is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Pausable,
    Ownable
{
    uint256 private _nextTokenId;

    address private _ownership;

    constructor(
        string memory collectionName,
        string memory collectionSymbol,
        address producer
    ) ERC721(collectionName, collectionSymbol) Ownable(producer) {
        // pause token transfers to make NFTs non-transferable by default
        _pause();
    }

    function createProduct(
        address to,
        string memory uri,
        bytes32 sigHash
    ) external onlyOwner {
        require(sigHash != 0, "Invalid signature hash");

        uint256 tokenId = _nextTokenId++;

        // mint the token to the tag address
        _unpause();
        _safeMint(to, tokenId);
        _pause();

        // set token metadata
        _setTokenURI(tokenId, uri);

        // set ownership signature hash
        (bool success, ) = _ownership.call(
            abi.encodeWithSignature("addSigHash(uint256,bytes32)", tokenId, sigHash)
        );
        require(success, "Ownership contract call failed");
    }

    function setOwnershipContract(address ownershipContract) external {
        require(_ownership == address(0), "Ownership contract already set");
        _ownership = ownershipContract;
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
