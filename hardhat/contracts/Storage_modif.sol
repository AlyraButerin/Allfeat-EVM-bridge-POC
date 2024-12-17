// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.20;

// import {TokenFactory} from "./TokenFactory.sol";
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

// /**
//  * @title Storage
//  * @notice This contract is the 'eternal storage' of the bridge
//  * @dev It stores the addresses of the tokens on the different chains
//  * @dev It stores the block confirmation needed for each chain
//  * @dev It stores the fees for each chain
//  * @dev It stores the addresses of the operators
//  */
// contract Storage {
//     using StorageKeyLibrary for string;
//     //****************************************************************** */
//     //
//     //              STATE VARIABLES
//     //
//     //****************************************************************** */

//     address constant MAX_ADDRESS = address(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
//     bytes32 constant NON_COMPOSITE_KEY = bytes32("NON_COMPOSITE_KEY");

//     mapping(bytes32 => uint256) internal s_uintStorage;
//     mapping(bytes32 => bytes32) internal s_bytes32Storage;
//     mapping(bytes32 => string) internal s_stringStorage;
//     mapping(bytes32 => bytes) internal s_bytesStorage;
//     mapping(bytes32 => address) internal s_addressStorage;
//     mapping(bytes32 => bool) internal s_boolStorage;

//     mapping(bytes32 => uint256[]) internal s_uintArrayStorage;
//     mapping(bytes32 => string[]) internal s_stringArrayStorage;
//     mapping(bytes32 => address[]) internal s_addressArrayStorage;

//     //****************************************************************** */
//     //
//     //              EVENTS
//     //
//     //****************************************************************** */

//     event Storage__TokenNameAdded(string tokenName);
//     event Storage__ChainIdAdded(uint256 chainId);

//     event Storage__TokenAddressSet(string tokenName, uint256 chainId, address tokenAddress);

//     event Storage__UintDataChanged(bytes32 key, uint256 newValue);
//     event Storage__AddressDataChanged(bytes32 key, address newValue);
//     event Storage__StringDataChanged(bytes32 key, string newValue);
//     event Storage__BoolDataChanged(bytes32 key, bool newValue);
//     event Storage__BytesDataChanged(bytes32 key, bytes newValue);
//     event Storage__Bytes32_DataChanged(bytes32 key, bytes32 newValue);

//     event Storage__UintArrayDataChanged(bytes32 key, uint256 index, uint256 newValue);
//     event Storage__AddressArrayDataChanged(bytes32 key, uint256 index, address newValue);
//     event Storage__StringArrayDataChanged(bytes32 key, uint256 index, string newValue);

//     event Storage__UintArrayChanged(bytes32 key, uint256[] newArray);
//     event Storage__AddressArrayChanged(bytes32 key, address[] newArray);
//     event Storage__StringArrayChanged(bytes32 key, string[] newArray);

//     //****************************************************************** */
//     //
//     //              CONSTRUCTOR / INITIALIZATION
//     //
//     //****************************************************************** */
//     /**
//      * @notice Sets the initial values
//      *
//      * @dev set native coin name and chainId
//      * @dev set default params (fees, block confimration..)
//      * @dev IMPORTANT: deployer of Storage is the admin of all contracts
//      *
//      * @param nativeTokenName name of the native coin
//      */
//     // @todo set storage manager add as writer with admin
//     constructor(string memory nativeTokenName) {
//         uint256 nativeChainId = block.chainid;

//         s_addressStorage[("admin").getKey()] = msg.sender;

//         addChainIdToList(nativeChainId);
//         addTokenNameToList(nativeTokenName);

//         addNewTokenAddressByChainId(nativeTokenName, nativeChainId, MAX_ADDRESS);
//         // set initial values
//         _setInitialValues();
//     }

//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     //
//     //                                   DATA GETTERS BY TYPE
//     //
//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     /**
//      * @notice Retrieves a uint256 value from storage using the specified key.
//      *
//      * @param key The bytes32 key associated with the uint256 value.
//      * @return uint256 The stored uint256 value.
//      */
//     function getUint(bytes32 key) public view returns (uint256) {
//         return s_uintStorage[key];
//     }

//     /**
//      * @notice Retrieves an address value from storage using the specified key.
//      *
//      * @param key The bytes32 key associated with the address value.
//      * @return address The stored address value.
//      */
//     function getAddress(bytes32 key) public view returns (address) {
//         return s_addressStorage[key];
//     }

//     /**
//      * @notice Retrieves the address value for the specified key.
//      *
//      * @dev This function is a duplicate of getAddress. It is a temporary fix due to a conflict with ethers.getAddress()
//      *      in tests/units/01_Storage.t.js.
//      *
//      * @param key The bytes32 key associated with the address value.
//      * @return address The stored address value.
//      */
//     function getAddr(bytes32 key) public view returns (address) {
//         return getAddress(key);
//     }

//     /**
//      * @notice Retrieves a boolean value from storage using the specified key.
//      *
//      * @param key The bytes32 key associated with the boolean value.
//      * @return bool The stored boolean value.
//      */
//     function getBool(bytes32 key) public view returns (bool) {
//         return s_boolStorage[key];
//     }

//     /**
//      * @notice Retrieves a bytes array value from storage using the specified key.
//      *
//      * @param key The bytes32 key associated with the bytes value.
//      * @return bytes The stored bytes value.
//      */
//     function getBytes(bytes32 key) public view returns (bytes memory) {
//         return s_bytesStorage[key];
//     }

//     /**
//      * @notice Retrieves a string value from storage using the specified key.
//      *
//      * @param key The bytes32 key associated with the string value.
//      * @return string The stored string value.
//      */
//     function getString(bytes32 key) public view returns (string memory) {
//         return s_stringStorage[key];
//     }

//     /**
//      * @notice Retrieves a bytes32 value from storage using the specified key.
//      *
//      * @param key The bytes32 key associated with the bytes32 value.
//      * @return bytes32 The stored bytes32 value.
//      */
//     function getBytes32(bytes32 key) public view returns (bytes32) {
//         return s_bytes32Storage[key];
//     }

//     /**
//      * @notice Retrieves an array of uint256 values from storage using the specified key.
//      *
//      * @param key The bytes32 key associated with the uint256 array.
//      * @return uint256[] The stored array of uint256 values.
//      */
//     function getUintArray(bytes32 key) public view returns (uint256[] memory) {
//         return s_uintArrayStorage[key];
//     }

//     /**
//      * @notice Retrieves an array of address values from storage using the specified key.
//      *
//      * @param key The bytes32 key associated with the address array.
//      * @return address[] The stored array of address values.
//      */
//     function getAddressArray(bytes32 key) public view returns (address[] memory) {
//         return s_addressArrayStorage[key];
//     }

//     /**
//      * @notice Retrieves an array of string values from storage using the specified key.
//      *
//      * @param key The bytes32 key associated with the string array.
//      * @return string[] The stored array of string values.
//      */
//     function getStringArray(bytes32 key) public view returns (string[] memory) {
//         return s_stringArrayStorage[key];
//     }

//     /**
//      * @notice Retrieves a specific value from a uint256 array using the specified key and index.
//      *
//      * @param key The bytes32 key associated with the uint256 array.
//      * @param index The index of the value to retrieve.
//      * @return uint256 The value from the uint256 array at the specified index.
//      */
//     function getUintArrayValue(bytes32 key, uint256 index) public view returns (uint256) {
//         return s_uintArrayStorage[key][index];
//     }

//     /**
//      * @notice Retrieves a specific value from an address array using the specified key and index.
//      *
//      * @param key The bytes32 key associated with the address array.
//      * @param index The index of the value to retrieve.
//      * @return address The value from the address array at the specified index.
//      */
//     function getAddressArrayValue(bytes32 key, uint256 index) public view returns (address) {
//         return s_addressArrayStorage[key][index];
//     }

//     /**
//      * @notice Retrieves a specific value from a string array using the specified key and index.
//      *
//      * @param key The bytes32 key associated with the string array.
//      * @param index The index of the value to retrieve.
//      * @return string The value from the string array at the specified index.
//      */
//     function getStringArrayValue(bytes32 key, uint256 index) public view returns (string memory) {
//         return s_stringArrayStorage[key][index];
//     }

//     struct Data {
//         uint256 uintValue;
//         string stringValue;
//         bytes byteValue;
//         address addrValue;
//     }

//     //@todo add storage pointers
//     //@todo evaluate gas cost and compare to assembly version with encode/decode method
//     //using bytes value in place of Data struct and results array
//     function getValues(bytes32[] calldata keys, string[] calldata types) external view returns (Data[] memory) {
//         require(keys.length == types.length, "Keys and types length mismatch");
//         Data[] memory results = new Data[](keys.length);

//         for (uint256 i = 0; i < keys.length; i++) {
//             if (keccak256(bytes(types[i])) == keccak256("uint")) {
//                 results[i].uintValue = s_uintStorage[keys[i]];
//             } else if (keccak256(bytes(types[i])) == keccak256("string")) {
//                 results[i].stringValue = s_stringStorage[keys[i]];
//             } else if (keccak256(bytes(types[i])) == keccak256("bytes")) {
//                 results[i].byteValue = s_bytesStorage[keys[i]];
//             } else if (keccak256(bytes(types[i])) == keccak256("address")) {
//                 results[i].addrValue = s_addressStorage[keys[i]];
//             } else {
//                 revert("Unsupported type");
//             }
//         }

//         return results;
//     }
//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     //
//     //                                   DATA SETTERS BY TYPE
//     //                               ONLY admin can access setters
//     //
//     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//     /* *****************SIMPLE VALUE ************************** */

//     function initAddress(bytes32 key, address value) public {
//         if (s_addressStorage[key] != address(0)) {
//             revert Storage__CanNotInitializeExistingAddress(key, value);
//         }
//         _setAddress(key, value);
//     }

//     function updateAddress(bytes32 key, address value) public {
//         if (s_addressStorage[key] == address(0)) {
//             revert Storage__CanNotUpdateNonExistingAddress(key, value);
//         }
//         _setAddress(key, value);
//     }

//     /**
//      * @notice Sets an address value in storage for the specified key.
//      *
//      * @param key The bytes32 key to associate with the address value.
//      * @param value The address value to store.
//      */
//     function _setAddress(bytes32 key, address value) private {
//         _checkAccess();
//         s_addressStorage[key] = value;
//         emit Storage__AddressDataChanged(key, value);
//     }

//     function initUint(bytes32 key, uint256 value) public {
//         if (s_uintStorage[key] != 0) {
//             revert Storage__CanNotInitializeExistingUint(key, address(value));
//         }
//         _setUint(key, value);
//     }

//     function updateUint(bytes32 key, uint256 value) public {
//         if (s_uintStorage[key] == 0) {
//             revert Storage__CanNotUpdateNonExistingUint(key, address(value));
//         }
//         _setUint(key, value);
//     }

//     /**
//      * @notice Sets a uint256 value in storage for the specified key.
//      *
//      * @param key The bytes32 key to associate with the uint256 value.
//      * @param value The uint256 value to store.
//      */
//     function _setUint(bytes32 key, uint256 value) private {
//         _checkAdminAccess();
//         s_uintStorage[key] = value;
//         emit Storage__UintDataChanged(key, value);
//     }

//     // probleme here
//     function initBool(bytes32 key, bool value) public {
//         if (s_boolStorage[key] != false) {
//             revert Storage__CanNotInitializeExistingBool(key, address(value));
//         }
//         _setBool(key, value);
//     }

//     /**
//      * @notice Sets a boolean value in storage for the specified key.
//      *
//      * @param key The bytes32 key to associate with the boolean value.
//      * @param value The boolean value to store.
//      */
//     function _setBool(bytes32 key, bool value) private {
//         _checkAdminAccess();
//         s_boolStorage[key] = value;
//         emit Storage__BoolDataChanged(key, value);
//     }

//     /**
//      * @notice Sets a bytes array value in storage for the specified key.
//      *
//      * @param key The bytes32 key to associate with the bytes value.
//      * @param value The bytes value to store.
//      */
//     function setBytes(bytes32 key, bytes memory value) public {
//         _checkAdminAccess();
//         s_bytesStorage[key] = value;
//         emit Storage__BytesDataChanged(key, value);
//     }

//     /**
//      * @notice Sets a string value in storage for the specified key.
//      *
//      * @param key The bytes32 key to associate with the string value.
//      * @param value The string value to store.
//      */
//     function setString(bytes32 key, string memory value) public {
//         _checkAdminAccess();
//         s_stringStorage[key] = value;
//         emit Storage__StringDataChanged(key, value);
//     }

//     /**
//      * @notice Sets a bytes32 value in storage for the specified key.
//      *
//      * @param key The bytes32 key to associate with the bytes32 value.
//      * @param value The bytes32 value to store.
//      */
//     function setBytes32(bytes32 key, bytes32 value) public {
//         _checkAdminAccess();
//         s_bytes32Storage[key] = value;
//         emit Storage__Bytes32_DataChanged(key, value);
//     }

//     /* ***************** ARRAYS ************************** */
//     /**
//      * @notice Sets an array of uint256 values in storage for the specified key.
//      *
//      * @param key The bytes32 key to associate with the uint256 array.
//      * @param array The array of uint256 values to store.
//      */
//     function setUintArray(bytes32 key, uint256[] memory array) public {
//         _checkAdminAccess();
//         s_uintArrayStorage[key] = array;
//         emit Storage__UintArrayChanged(key, array);
//     }

//     /**
//      * @notice Sets an array of address values in storage for the specified key.
//      *
//      * @param key The bytes32 key to associate with the address array.
//      * @param array The array of address values to store.
//      */
//     function setAddressArray(bytes32 key, address[] memory array) public {
//         _checkAdminAccess();
//         s_addressArrayStorage[key] = array;
//         emit Storage__AddressArrayChanged(key, array);
//     }

//     /**
//      * @notice Sets an array of string values in storage for the specified key.
//      *
//      * @param key The bytes32 key to associate with the string array.
//      * @param array The array of string values to store.
//      */
//     function setStringArray(bytes32 key, string[] memory array) public {
//         _checkAdminAccess();
//         s_stringArrayStorage[key] = array;
//         emit Storage__StringArrayChanged(key, array);
//     }

//     /* *****************ARRAY VALUE ************************** */

//     /**
//      * @notice Adds a value to a uint256 array stored under the specified key.
//      *
//      * @param key The bytes32 key associated with the uint256 array.
//      * @param value The uint256 value to add to the array.
//      */
//     function addToUintArray(bytes32 key, uint256 value) public {
//         _checkAdminAccess();
//         uint256[] storage array = s_uintArrayStorage[key];
//         array.push(value);
//         emit Storage__UintArrayDataChanged(key, array.length - 1, value);
//     }

//     /**
//      * @notice Adds a value to an address array stored under the specified key.
//      *
//      * @param key The bytes32 key associated with the address array.
//      * @param value The address value to add to the array.
//      */
//     function addToAddressArray(bytes32 key, address value) public {
//         _checkAdminAccess();
//         address[] storage array = s_addressArrayStorage[key];
//         array.push(value);
//         emit Storage__AddressArrayDataChanged(key, array.length - 1, value);
//     }

//     /**
//      * @notice Adds a value to a string array stored under the specified key.
//      *
//      * @param key The bytes32 key associated with the string array.
//      * @param value The string value to add to the array.
//      */
//     function addToStringArray(bytes32 key, string calldata value) public {
//         _checkAdminAccess();
//         string[] storage array = s_stringArrayStorage[key];
//         array.push(value);
//         emit Storage__StringArrayDataChanged(key, array.length - 1, value);
//     }

//     /**
//      * @notice Updates a specific value in a uint256 array stored under the specified key.
//      *
//      * @param key The bytes32 key associated with the uint256 array.
//      * @param index The index of the value to update.
//      * @param value The new uint256 value to set at the specified index.
//      * @dev Reverts if the index is out of bounds.
//      */
//     function updateUintArray(bytes32 key, uint256 index, uint256 value) public {
//         _checkAdminAccess();
//         if (index >= s_uintArrayStorage[key].length) {
//             revert Storage__InvalidArrayLengthInParams("updateUintArray");
//         }
//         s_uintArrayStorage[key][index] = value;
//         emit Storage__UintArrayDataChanged(key, index, value);
//     }

//     /**
//      * @notice Updates a specific value in an address array stored under the specified key.
//      *
//      * @param key The bytes32 key associated with the address array.
//      * @param index The index of the value to update.
//      * @param value The new address value to set at the specified index.
//      * @dev Reverts if the index is out of bounds.
//      */
//     function updateAddressArray(bytes32 key, uint256 index, address value) public {
//         _checkAdminAccess();
//         if (index >= s_addressArrayStorage[key].length) {
//             revert Storage__InvalidArrayLengthInParams("updateAddressArray");
//         }
//         s_addressArrayStorage[key][index] = value;
//         emit Storage__AddressArrayDataChanged(key, index, value);
//     }

//     /**
//      * @notice Updates a specific value in a string array stored under the specified key.
//      *
//      * @param key The bytes32 key associated with the string array.
//      * @param index The index of the value to update.
//      * @param value The new string value to set at the specified index.
//      * @dev Reverts if the index is out of bounds.
//      */
//     function updateStringArray(bytes32 key, uint256 index, string calldata value) public {
//         _checkAdminAccess();
//         if (index >= s_stringArrayStorage[key].length) {
//             revert Storage__InvalidArrayLengthInParams("updateStringArray");
//         }
//         s_stringArrayStorage[key][index] = value;
//         emit Storage__StringArrayDataChanged(key, index, value);
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
//             revert Storage__NotAdmin();
//         }
//     }

//     /**
//      * @notice Checks that the sender has access (admin or factory).
//      *
//      * @dev Reverts if the sender is neither the admin nor the factory.
//      */
//     function _checkAccess() private view {
//         if (!_isAdmin() && !_isFactory()) {
//             revert Storage__NotAdmin();
//         }
//     }
// }
