// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.20;

// import {TokenFactory} from "./TokenFactory.sol";
// import {Storage} from "./Storage.sol";
// import {StorageKeyLibrary} from "./StorageKeyLibrary.sol";
// import {Errors} from "./Errors.sol";

// /**
//  * @title Storage
//  * @notice This contract is the 'eternal storage' of the bridge
//  * @dev It stores the addresses of the tokens on the different chains
//  * @dev It stores the block confirmation needed for each chain
//  * @dev It stores the fees for each chain
//  * @dev It stores the addresses of the operators
//  */
// contract StorageManager {
//     // using StorageKeyLibrary for string;

//     Storage private s_storage;

//     // remove
//     address private s_owner;
//     // @todo compelte constructor
//     // should set writer add (this) in storage for access control

//     constructor(address _storage) {
//         s_storage = Storage(_storage);
//         // The owner of the contract is the deployer
//         s_owner = msg.sender;
//     }

//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     //
//     //                                      ROLES HELPERS (registry not RBAC)
//     //
//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     /**
//      * @notice Updates the address of an operator associated with a specific role.
//      *
//      * @param role The role of the operator to update.
//      * @param newOperator The new address to assign to the operator's role.
//      */
//     function updateOperator(string calldata role, address newOperator) public {
//         s_storage.setAddress(role.getKey(), newOperator);
//     }

//     /**
//      * @notice Updates the addresses of a batch of operators associated with their roles.
//      *
//      * @param roles An array of roles corresponding to the operators to update.
//      * @param newOperators An array of new operator addresses to assign to the respective roles.
//      * @dev Reverts if the lengths of roles and newOperators arrays do not match.
//      */
//     function batchUpdateOperators(string[] calldata roles, address[] calldata newOperators) public {
//         if (roles.length != newOperators.length) {
//             revert Errors.Storage__InvalidArrayLengthInParams("updatOperators");
//         }
//         for (uint256 i; i < roles.length;) {
//             updateOperator(roles[i], newOperators[i]);
//             unchecked {
//                 ++i;
//             }
//         }
//     }

//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     //
//     //                                          TOKEN NAMES AND CHAIN IDS
//     //
//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//     /*
//     * This function has security purposes by forcing 2-step actions when adding a token.
//     */

//     /**
//      * @notice Adds a token name to the list of authorized tokens.
//      *
//      * @param tokenName The name of the token to add to the authorized list.
//      * @dev Reverts if the token name is already in the list.
//      */
//     function addTokenNameToList(string memory tokenName) public {
//         _checkAdminAccess();
//         if (isTokenNameInList(tokenName)) {
//             revert Errors.Storage__TokenAlreadyInList(tokenName);
//         }
//         string[] storage list = s_stringArrayStorage[("tokenNamesList").getKey()];
//         list.push(tokenName);

//         emit Storage__TokenNameAdded(tokenName);
//     }

//     /**
//      * @notice Adds a batch of token names to the list of authorized tokens.
//      *
//      * @param tokenNames An array of token names to add to the authorized list.
//      */
//     function batchAddTokenNamesToList(string[] calldata tokenNames) external {
//         for (uint256 i; i < tokenNames.length;) {
//             addTokenNameToList(tokenNames[i]);
//             unchecked {
//                 ++i;
//             }
//         }
//     }

//     /**
//      * @notice Adds a chain ID to the list of authorized chains.
//      *
//      * @param chainId The ID of the chain to add to the authorized list.
//      * @dev Reverts if the chain ID is already in the list.
//      */
//     function addChainIdToList(uint256 chainId) public {
//         _checkAdminAccess();
//         if (StorageKeyLibrary.isChainIdInList(s_storage, chainId)) {
//             revert Errors.Storage__ChainIdAlreadyInList(chainId);
//         }
//         uint256[] storage list = s_uintArrayStorage[("chainIdsList").getKey()];
//         list.push(chainId);

//         emit Storage__ChainIdAdded(chainId);
//     }

//     /**
//      * @notice Adds a batch of chain IDs to the list of authorized chains.
//      *
//      * @param chainIds An array of chain IDs to add to the authorized list.
//      */
//     function batchAddChainIdsToList(uint256[] calldata chainIds) external {
//         for (uint256 i; i < chainIds.length;) {
//             addChainIdToList(chainIds[i]);
//             unchecked {
//                 ++i;
//             }
//         }
//     }

//     ///////////////////////////////////////////////////////////////////////////////////////////////
//     //
//     //                              TOKENS MANAGEMENT
//     //
//     ///////////////////////////////////////////////////////////////////////////////////////////////

//     /**
//      * @notice Adds a new address and chain ID for a specified token name.
//      *
//      * @param tokenName The name of the token to which the address should be assigned.
//      * @param chainId The ID of the chain on which the token address is being added.
//      * @param tokenAddress The address of the token to add.
//      * @dev Reverts if the token name or chain ID is not in the authorized lists or if the address is already set.
//      */
//     function addNewTokenAddressByChainId(string memory tokenName, uint256 chainId, address tokenAddress) public {
//         if (!isTokenNameInList(tokenName)) {
//             revert Errors.Storage__TokenNotInList(tokenName);
//         }
//         if (!isChainIdInList(chainId)) {
//             revert Errors.Storage__ChainIdNotInList(chainId);
//         }
//         if (getTokenAddressByChainId(tokenName, chainId) != address(0)) {
//             revert Errors.Storage__TokenAddressAlreadySet(tokenName, chainId);
//         }
//         _setTokenAddressByChainId(tokenName, chainId, tokenAddress);
//     }

//     /**
//      * @notice Updates the address of a specified token on a specific chain.
//      *
//      * @param tokenName The name of the token for which the address should be updated.
//      * @param chainId The ID of the chain on which the token address is being updated.
//      * @param tokenAddress The new address of the token.
//      * @dev Reverts if the token name or chain ID is not in the authorized lists or if the old address does not exist.
//      */
//     function updateTokenAddressByChainId(string memory tokenName, uint256 chainId, address tokenAddress) public {
//         address oldAddress = getTokenAddressByChainId(tokenName, chainId);
//         if (!isTokenNameInList(tokenName)) {
//             revert Errors.Storage__TokenNotInList(tokenName);
//         }
//         if (!isChainIdInList(chainId)) {
//             revert Errors.Storage__ChainIdNotInList(chainId);
//         }
//         if (oldAddress == address(0)) {
//             revert Errors.Storage__TokenAddressNotSet(tokenName, chainId);
//         }
//         _setTokenAddressByChainId(tokenName, chainId, tokenAddress);
//     }

//     /**
//      * @notice Adds a set of new addresses and chain IDs for specified token names.
//      *
//      * @param tokenNames An array of token names to which addresses should be assigned.
//      * @param chainIds An array of chain IDs corresponding to the token names.
//      * @param tokenAddresses An array of addresses to assign to the respective token names and chain IDs.
//      * @dev Reverts if the lengths of the input arrays do not match.
//      */
//     function batchAddNewTokensAddressesByChainId(
//         string[] memory tokenNames,
//         uint256[] memory chainIds,
//         address[] memory tokenAddresses
//     ) public {
//         _checkAccess();
//         if (tokenNames.length != chainIds.length || chainIds.length != tokenAddresses.length) {
//             revert Errors.Storage__InvalidArrayLengthInParams("batchAddTokenAddressessByChainId");
//         }

//         for (uint256 i = 0; i < tokenNames.length;) {
//             addNewTokenAddressByChainId(tokenNames[i], chainIds[i], tokenAddresses[i]);
//             unchecked {
//                 ++i;
//             }
//         }
//     }

//     //****************************************************************** //
//     //              PRIVATE FUNCTIONS
//     //****************************************************************** //

//     /**
//      * @notice Sets initial values for the contract, including default parameters.
//      *
//      * @dev This is a draft version to ease development and testing.
//      *      To be refactored when block checks and fees management are implemented.
//      */
//     function _setInitialValues() private {
//         // blockToWait for confirmation on chainId
//         setUint(("blockToWait").getKey(1), 6); //........... eth
//         setUint(("blockToWait").getKey(11155111), 6); //.... sepolia
//         setUint(("blockToWait").getKey(441), 2); //......... harmonie (allfeat testnet)
//         setUint(("blockToWait").getKey(31337), 2); //....... hardhat
//         setUint(("blockToWait").getKey(440), 2); //......... harmonieLocal
//         setUint(("blockToWait").getKey(1337), 2); //........ geth

//         // operational fees on chainId
//         uint256 opFees = 0.001 ether;
//         setUint(("opFees").getKey(1), opFees); //........... eth
//         setUint(("opFees").getKey(11155111), opFees); //.... sepolia
//         setUint(("opFees").getKey(441), opFees); //......... harmonie (allfeat testnet)
//         setUint(("opFees").getKey(31337), opFees); //....... hardhat
//         setUint(("opFees").getKey(440), opFees); //......... harmonieLocal
//         setUint(("opFees").getKey(1337), opFees); //........ geth

//         // protocol fees
//         uint256 protocolPercentFees = 1000; // 0.1%
//         setUint(("protocolPercentFees").getKey(1), protocolPercentFees); //....... eth
//         setUint(("protocolPercentFees").getKey(11155111), protocolPercentFees); // sepolia
//         setUint(("protocolPercentFees").getKey(441), protocolPercentFees); //..... harmonie (allfeat testnet)
//         setUint(("protocolPercentFees").getKey(31337), protocolPercentFees); //... hardhat
//         setUint(("protocolPercentFees").getKey(440), protocolPercentFees); //..... harmonieLocal
//         setUint(("protocolPercentFees").getKey(1337), protocolPercentFees); //.... geth
//     }

//     /**
//      * @notice Checks if the sender is the admin.
//      *
//      * @return bool True if the sender is the admin, false otherwise.
//      */
//     function _isAdmin() private view returns (bool) {
//         return getOperator("admin") == msg.sender;
//     }

//     /**
//      * @notice Checks if the sender is the factory.
//      *
//      * @return bool True if the sender is the factory, false otherwise.
//      */
//     function _isFactory() private view returns (bool) {
//         return getOperator("factory") == msg.sender;
//     }

//     /**
//      * @notice Checks that the sender has admin access.
//      *
//      * @dev Reverts if the sender is not the admin.
//      */
//     function _checkAdminAccess() private view {
//         if (!_isAdmin()) {
//             revert Errors.Storage__NotAdmin();
//         }
//     }

//     /**
//      * @notice Checks that the sender has access (admin or factory).
//      *
//      * @dev Reverts if the sender is neither the admin nor the factory.
//      */
//     function _checkAccess() private view {
//         if (!_isAdmin() && !_isFactory()) {
//             revert Errors.Storage__NotAdmin();
//         }
//     }

//     /**
//      * @notice Sets the token address for a specified token name and chain ID.
//      *
//      * @param tokenName The name of the token for which the address is being set.
//      * @param chainId The ID of the chain on which the token address is being set.
//      * @param tokenAddress The address of the token to set.
//      * @dev Emits a Storage__TokenAddressSet event upon success.
//      */
//     function _setTokenAddressByChainId(string memory tokenName, uint256 chainId, address tokenAddress) private {
//         setAddress(getKey(tokenName, chainId), tokenAddress);
//         emit Errors.Storage__TokenAddressSet(tokenName, chainId, tokenAddress);
//     }
// }
