// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./RadixTag.sol";

/// @custom:security-contact francescolaterza00@gmail.com
contract RadixOwnership is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    address private immutable _tag;

    mapping (uint256 => bytes32) private _tokenIdToSigHash;

    constructor(
        string memory collectionName,
        string memory collectionSymbol,
        address producer,
        address tag
    ) ERC721(collectionName, collectionSymbol) Ownable(producer) {
        _tag = tag;
    }

    function claimOwnership(
        uint256 tokenId,
        bytes[64] memory sig
    ) public {
        // check that the signature exists
        require(_tokenIdToSigHash[tokenId] != 0, "Tag has not been created yet");

        // check that the signature is valid
        require(_tokenIdToSigHash[tokenId] == keccak256(abi.encode(sig)), "Invalid signature");

        // mint the token to the sender
        _safeMint(msg.sender, tokenId);

        // create the uri
        string memory uri = RadixTag(_tag).tokenURI(tokenId);
        _setTokenURI(tokenId, string(abi.encodePacked(uri, " owner")));
    }

    function addSigHash(uint256 tokenId, bytes32 sigHash) external {
        require(msg.sender == _tag, "Only the tag contract can call this function");
        require(_tokenIdToSigHash[tokenId] == 0, "Tag has already been created");

        _tokenIdToSigHash[tokenId] = sigHash;
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
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
