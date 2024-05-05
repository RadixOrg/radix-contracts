// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RadixRouter is Ownable {
    mapping(uint256 => mapping(uint256 => address[2])) private _contracts;

    constructor() Ownable(msg.sender) {}

    function addContracts(
        uint256 producerId,
        uint256 collectionId,
        address tag,
        address ownership
    ) public onlyOwner {
        require(
            _contracts[producerId][collectionId][0] == address(0),
            "Contracts already set"
        );

        _contracts[producerId][collectionId][0] = tag;
        _contracts[producerId][collectionId][1] = ownership;
    }

    function addContracts(
        uint256 producerId,
        uint256 collectionId,
        address tag
    ) public onlyOwner {
        require(
            _contracts[producerId][collectionId][0] == address(0),
            "Contracts already set"
        );

        _contracts[producerId][collectionId][0] = tag;
    }

    function getCollection(
        uint256 producerId,
        uint256 collectionId
    ) public view returns (address, address) {
        return (
            _contracts[producerId][collectionId][0],
            _contracts[producerId][collectionId][1]
        );
    }
}
