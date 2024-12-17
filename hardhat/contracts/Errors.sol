// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

library Errors {
    ///////////// STORAGE ERRORS /////////////

    /// Storage
    error Storage__CanNotInitializeExistingAddress(bytes32 key, address value);
    error Storage__CanNotUpdateNonExistingAddress(bytes32 key, address value);

    /// StorageRead
    error Storage__NotAdmin();
    error Storage__TokenNotInList(string tokenName);
    error Storage__ChainIdNotInList(uint256 chainId);
    error Storage__InvalidArrayLengthInParams(string functionName);
    error Storage__TokenAlreadyInList(string tokenName);
    error Storage__ChainIdAlreadyInList(uint256 chainId);
    error Storage__TokenAddressAlreadySet(string tokenName, uint256 chainId);
    error Storage__TokenAddressNotSet(string tokenName, uint256 chainId);
    error Storage__StringLongerThan32Bytes();

    /// StorageManager
    // @todo to complete
}
