// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// import "./RadixTag.sol";
// import "./RadixOwnership.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";

// struct Collection {
//     string name;
//     address tag;
//     address ownership;
// }

// contract RadixFactory is Ownable {
//     mapping(uint256 => Collection) private _collections;

//     constructor() Ownable(msg.sender) {}

//     function createCollection(
//         uint256 _collectionId,
//         string memory name,
//         string memory symbol
//     ) public onlyOwner {
//         address tagContract = address(new RadixTag(name, symbol, msg.sender));
//         address ownershipContract = address(new RadixOwnership(
//             name,
//             symbol,
//             msg.sender,
//             tagContract
//         ));
//         RadixTag(tagContract).setOwnershipContract(ownershipContract);

//         _collections[_collectionId] = Collection(
//             name,
//             address(tagContract),
//             address(ownershipContract)
//         );
//     }

//     function getCollection(uint256 _collectionId)
//         public
//         view
//         returns (Collection memory)
//     {
//         return _collections[_collectionId];
//     }
// }
