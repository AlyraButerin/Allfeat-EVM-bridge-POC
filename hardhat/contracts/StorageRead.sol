// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.20;

// import {TokenFactory} from "./TokenFactory.sol";
// import {Storage} from "./Storage.sol";
// import {StorageKeyLibrary} from "./StorageKeyLibrary.sol";

// error Storage__NotAdmin();
// error Storage__TokenNotInList(string tokenName);
// error Storage__ChainIdNotInList(uint256 chainId);
// error Storage__InvalidArrayLengthInParams(string functionName);
// error Storage__TokenAlreadyInList(string tokenName);
// error Storage__ChainIdAlreadyInList(uint256 chainId);
// error Storage__TokenAddressAlreadySet(string tokenName, uint256 chainId);
// error Storage__TokenAddressNotSet(string tokenName, uint256 chainId);
// error Storage__StringLongerThan32Bytes();

// error Storage__CanNotInitializeExistingAddress(bytes32 key, address value);
// error Storage__CanNotUpdateNonExistingAddress(bytes32 key, address value);

// // @todo RENAME READER
// /**
//  * @title Storage
//  * @notice This contract is the 'eternal storage' of the bridge
//  * @dev It stores the addresses of the tokens on the different chains
//  * @dev It stores the block confirmation needed for each chain
//  * @dev It stores the fees for each chain
//  * @dev It stores the addresses of the operators
//  */
// library StorageRead {
//     // @todo compelte constructor
//     // should set writer add (this) in storage for access control
//     // constructor(address _storage) {
//     //     s_storage = Storage(_storage);
//     //     // The owner of the contract is the deployer
//     //     s_owner = msg.sender;
//     // }

//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     //
//     //                                      ROLES HELPERS (registry not RBAC)
//     //
//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//     /**
//      * @notice Retrieves the address of an operator associated with a specific role.
//      *
//      * @param role The role of the operator to retrieve.
//      * @return address The address of the operator associated with the specified role.
//      */
//     function getOperator(Storage store, string memory role) public view returns (address) {
//         return store.getAddress(StorageKeyLibrary.getKey(role));
//     }

//     /**
//      * @notice Retrieves the addresses of a batch of operators associated with their roles.
//      *
//      * @param roles An array of roles for which to retrieve operator addresses.
//      * @return address[] An array of addresses corresponding to the specified roles.
//      */
//     function getOperators(Storage store, string[] memory roles) public view returns (address[] memory) {
//         address[] memory operators = new address[](roles.length);
//         for (uint256 i; i < roles.length;) {
//             operators[i] = store.getOperator(roles[i]);
//             unchecked {
//                 ++i;
//             }
//         }
//         return operators;
//     }

//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     //
//     //                                      ROLES HELPERS (futur RBAC part)
//     //
//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//     /**
//      * @notice Checks if a specified role is assigned to a given address.
//      *
//      * @param role The role to check.
//      * @param addr The address to verify against the specified role.
//      * @return bool True if the address is assigned to the specified role, false otherwise.
//      */
//     function isRole(Storage store, string calldata role, address addr) public view returns (bool) {
//         return store.getOperator(role) == addr;
//     }

//     /**
//      * @notice Checks if a batch of roles are assigned to their corresponding operator addresses.
//      *
//      * @param roles An array of roles to check.
//      * @param operators An array of addresses to verify against the specified roles.
//      * @return bool True if all roles are correctly assigned to their respective addresses, false otherwise.
//      * @dev Reverts if the lengths of roles and operators arrays do not match.
//      */
//     function checkOperators(Storage store, string[] memory roles, address[] memory operators)
//         public
//         view
//         returns (bool)
//     {
//         if (roles.length != operators.length) {
//             revert Storage__InvalidArrayLengthInParams("checkOperators");
//         }
//         for (uint256 i = 0; i < roles.length; i++) {
//             if (store.getOperator(roles[i]) != operators[i]) {
//                 return false;
//             }
//         }
//         return true;
//     }

//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     //
//     //                                          TOKEN NAMES AND CHAIN IDS
//     //
//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     /**
//      * @notice Retrieves the list of authorized token names.
//      *
//      * @return string[] An array of authorized token names.
//      */
//     function getTokenNamesList() public view returns (string[] memory) {
//         return getStringArray(("tokenNamesList").getKey());
//     }

//     /**
//      * @notice Checks if a token name is in the list of authorized tokens.
//      *
//      * @param tokenName The name of the token to check.
//      * @return bool True if the token name is in the authorized list, false otherwise.
//      */
//     function isTokenNameInList(string memory tokenName) public view returns (bool) {
//         string[] memory list = getStringArray(("tokenNamesList").getKey());
//         for (uint256 i = 0; i < list.length; i++) {
//             if (keccak256(abi.encodePacked(list[i])) == keccak256(abi.encodePacked(tokenName))) {
//                 return true;
//             }
//         }
//         return false;
//     }

//     /**
//      * @notice Retrieves the list of authorized chain IDs.
//      *
//      * @return uint256[] An array of authorized chain IDs.
//      */
//     function getChainIdsList() public view returns (uint256[] memory) {
//         return getUintArray(("chainIdsList").getKey());
//     }

//     /**
//      * @notice Checks if a specified chain ID is in the list of authorized chains.
//      *
//      * @param chainId The chain ID to check.
//      * @return bool True if the chain ID is in the authorized list, false otherwise.
//      */
//     function isChainIdInList(uint256 chainId) public view returns (bool) {
//         uint256[] memory list = getUintArray(("chainIdsList").getKey());
//         for (uint256 i = 0; i < list.length;) {
//             if (list[i] == chainId) {
//                 return true;
//             }
//             unchecked {
//                 ++i;
//             }
//         }
//         return false;
//     }

//     ///////////////////////////////////////////////////////////////////////////////////////////////
//     //
//     //                              TOKENS MANAGEMENT
//     //
//     ///////////////////////////////////////////////////////////////////////////////////////////////

//     /*
//      * Native coin are set with MAX_ADDRESS
//      * Authorized tokens have address != address(0)
//      * Storage of tokens representation: mapping(hash(tokenName,chainId) => address)
//      *
//      * @todo modification with packing: status(up/down),tokenSymbol,...,address
//      * and func to extract with bit shifting
//      * @todo manage new versin of token => having 2 addresses for the same token (old/new)
//      */

//     /**
//      * @notice Retrieves the address of a specified token on a specific chain.
//      *
//      * @param tokenName The name of the token to look up.
//      * @param chainId The ID of the chain on which to find the token's address.
//      * @return address The address of the token on the specified chain.
//      */
//     function getTokenAddressByChainId(string memory tokenName, uint256 chainId) public view returns (address) {
//         return getAddress((tokenName, chainId).getKey());
//     }

//     /**
//      * @notice Retrieves the addresses of a specified token on both the origin and destination chains.
//      *
//      * @param tokenName The name of the token to look up.
//      * @param originChainId The ID of the origin chain.
//      * @param destinationChainId The ID of the destination chain.
//      * @return originChainAddress The address of the token on the origin chain.
//      * @return destinationChainAddress The address of the token on the destination chain.
//      */
//     function getTokenAddressesByChainIds(string memory tokenName, uint256 originChainId, uint256 destinationChainId)
//         public
//         view
//         returns (address originChainAddress, address destinationChainAddress)
//     {
//         originChainAddress = getTokenAddressByChainId(tokenName, originChainId);
//         destinationChainAddress = getTokenAddressByChainId(tokenName, destinationChainId);
//     }

//     /**
//      * @notice Checks if a specified token name on a specific chain ID is authorized.
//      *
//      * @param tokenName The name of the token to check.
//      * @param chainId The ID of the chain to check against.
//      * @return bool True if the token is authorized on the specified chain, false otherwise.
//      */
//     function isAuthorizedTokenByChainId(string memory tokenName, uint256 chainId) public view returns (bool) {
//         return getTokenAddressByChainId(tokenName, chainId) != address(0);
//     }
// }
