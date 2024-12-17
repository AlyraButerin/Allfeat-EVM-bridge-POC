// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// library StorageKeyLibrary {
//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     //
//     //                                   KEY GENERATORS
//     //
//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     // @todo Clean key generators when refactoring done
//     // @todo Only bytes32 inputs or keep readable types inputs ?
//     bytes32 constant NON_COMPOSITE_KEY = bytes32("NON_COMPOSITE_KEY");

//     /**
//      * @notice Computes a storage key by hashing the provided string 'key'.
//      *
//      * @param key The string representation of the key to store in the eternal storage.
//      * @return bytes32 The hashed representation of the storage key.
//      */
//     function getKey(string memory key) internal pure returns (bytes32) {
//         return _getKey(_stringToBytes32(key), NON_COMPOSITE_KEY);
//     }

//     /**
//      * @notice Computes a hash of a composite key formed by the provided 'key' and an Ethereum address.
//      *
//      * @param key The string representation of the key to hash.
//      * @param addr The Ethereum address to combine with the key for unique identification.
//      * @return bytes32 The hashed representation of the composite key (key + address).
//      */
//     function getKey(string memory key, address addr) internal pure returns (bytes32) {
//         return _getKey(_stringToBytes32(key), bytes32(uint256(uint160(addr))));
//     }

//     /**
//      * @notice Computes a hash of a composite key formed by the provided 'key' and a uint256 number.
//      *
//      * @param key The string representation of the key to hash.
//      * @param number The uint256 number to combine with the key for unique identification.
//      * @return bytes32 The hashed representation of the composite key (key + number).
//      */
//     function getKey(string memory key, uint256 number) internal pure returns (bytes32) {
//         return _getKey(_stringToBytes32(key), bytes32(number));
//     }

//     function _getKey(bytes32 label1, bytes32 label2) private pure returns (bytes32 key) {
//         assembly {
//             mstore(0x00, label1)
//             mstore(0x20, label2)
//             key := keccak256(0x00, 0x40)
//         }
//     }

//     function _stringToBytes32(string memory str) private pure returns (bytes32) {
//         if (bytes(str).length > 32) {
//             revert("String longer than 32 bytes");
//         }
//         return bytes32(bytes(str));
//     }
// }
