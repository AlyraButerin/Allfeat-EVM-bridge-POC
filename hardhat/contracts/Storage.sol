// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Eternal storage for the bridge ecosyste allowing to upgrade modules

// @todo
// refactor and add events
// add fees variables (op, base, protocol, etc.)
// keep only needed storage
// store all varibles without balances (managed by vault) and operation (managed by relayer)
contract Storage {
    mapping(bytes32 => uint256) internal s_uintStorage;
    mapping(bytes32 => address) internal s_addressStorage;
    mapping(bytes32 => bool) internal s_boolStorage;
    mapping(bytes32 => bytes) internal s_bytesStorage;
    mapping(bytes32 => string) internal s_stringStorage;
    mapping(bytes32 => int256) internal s_intStorage;
    mapping(bytes32 => bytes32) internal s_bytes32Storage;
    mapping(bytes32 => uint256[]) internal s_uintArrayStorage;
    mapping(bytes32 => address[]) internal s_addressArrayStorage;
    mapping(bytes32 => bytes[]) internal s_bytesArrayStorage;
    mapping(bytes32 => string[]) internal s_stringArrayStorage;
    mapping(bytes32 => bytes32[]) internal s_bytes32ArrayStorage;
    mapping(bytes32 => int256[]) internal s_intArrayStorage;

    // optimization : bitmap for auth and bridged tokens OR only ussing tokenHere
    // mapping(address => bool) public authorizedTokens; //bool storage
    // mapping(uint256 => bool) public authorizedChains; // bool storage
    // mapping(address => bool) public bridgedTokens;
    // modif : // mapping(address => uint) public bridgedTokensToOriginChainId;
    // uint is the origin chainId (0 = not bridged, not created)
    // address[] public bridgedTokensList;
    mapping(address tokenAddress => mapping(uint256 chainId => address tokenAddressOnChainId)) public tokensMapping;
    // address[] public tokensList;
    // uint256[] public chainIdsList;

    // @todo IMPORTANT
    // make nonreeentrant var for all the system via transient storage

    // chainId eth == 1(0x1), sepolia == 11155111 (0xaa36a7), allfeat  441
    // TEMPORARY (define real value) blockToWait : blockId eth : 6 , allfeat : 2
    function setInitialValues() public {
        // blockToWait for confirmation on chainId
        setUint(getKey("blockToWait", 1), 6); // eth
        setUint(getKey("blockToWait", 11155111), 6); // sepolia
        setUint(getKey("blockToWait", 441), 2); // allfeat
        // operational fees on chainId
        uint256 opFees = 0.001 ether;
        setUint(getKey("opFees", 1), opFees); // eth
        setUint(getKey("opFees", 11155111), opFees); // sepolia
        setUint(getKey("opFees", 441), opFees); // allfeat

        // protocol fees
        uint256 protocolPercentFees = 1000; // 0.1%
        setUint(getKey("protocolPercentFees", 1), protocolPercentFees); // eth
        setUint(getKey("protocolPercentFees", 11155111), protocolPercentFees); // sepolia
        setUint(getKey("protocolPercentFees", 441), protocolPercentFees); // allfeat
    }

    // key management functions
    function getKey(string memory key) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(key));
    }
    // get key by name and address

    function getKey(string memory key, address addr) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(key, addr));
    }
    // get key by name and uint

    function getKey(string memory key, uint256 number) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(key, number));
    }

    // all getters for s_xxxStorage where xxx ist the type of the storage
    function getUint(bytes32 key) public view returns (uint256) {
        return s_uintStorage[key];
    }

    function getAddress(bytes32 key) public view returns (address) {
        return s_addressStorage[key];
    }

    function getBool(bytes32 key) public view returns (bool) {
        return s_boolStorage[key];
    }

    function getBytes(bytes32 key) public view returns (bytes memory) {
        return s_bytesStorage[key];
    }

    function getString(bytes32 key) public view returns (string memory) {
        return s_stringStorage[key];
    }

    function getInt(bytes32 key) public view returns (int256) {
        return s_intStorage[key];
    }

    function getBytes32(bytes32 key) public view returns (bytes32) {
        return s_bytes32Storage[key];
    }

    function getUintArray(bytes32 key) public view returns (uint256[] memory) {
        return s_uintArrayStorage[key];
    }

    function getAddressArray(bytes32 key) public view returns (address[] memory) {
        return s_addressArrayStorage[key];
    }

    function getBytesArray(bytes32 key) public view returns (bytes[] memory) {
        return s_bytesArrayStorage[key];
    }

    function getStringArray(bytes32 key) public view returns (string[] memory) {
        return s_stringArrayStorage[key];
    }

    function getBytes32Array(bytes32 key) public view returns (bytes32[] memory) {
        return s_bytes32ArrayStorage[key];
    }

    function getIntArray(bytes32 key) public view returns (int256[] memory) {
        return s_intArrayStorage[key];
    }

    // all setters for s_xxxStorage where xxx ist the type of the storage
    function setUint(bytes32 key, uint256 value) public {
        s_uintStorage[key] = value;
    }

    function setAddress(bytes32 key, address value) public {
        s_addressStorage[key] = value;
    }

    function setBool(bytes32 key, bool value) public {
        s_boolStorage[key] = value;
    }

    function setBytes(bytes32 key, bytes memory value) public {
        s_bytesStorage[key] = value;
    }

    function setString(bytes32 key, string memory value) public {
        s_stringStorage[key] = value;
    }

    function setInt(bytes32 key, int256 value) public {
        s_intStorage[key] = value;
    }

    function setBytes32(bytes32 key, bytes32 value) public {
        s_bytes32Storage[key] = value;
    }

    function setUintArray(bytes32 key, uint256[] memory value) public {
        s_uintArrayStorage[key] = value;
    }

    function setAddressArray(bytes32 key, address[] memory value) public {
        s_addressArrayStorage[key] = value;
    }

    function setBytesArray(bytes32 key, bytes[] memory value) public {
        s_bytesArrayStorage[key] = value;
    }

    function setStringArray(bytes32 key, string[] memory value) public {
        s_stringArrayStorage[key] = value;
    }

    function setBytes32Array(bytes32 key, bytes32[] memory value) public {
        s_bytes32ArrayStorage[key] = value;
    }

    function setIntArray(bytes32 key, int256[] memory value) public {
        s_intArrayStorage[key] = value;
    }

    // delete functions for all types of storage
    function deleteUint(bytes32 key) public {
        delete s_uintStorage[key];
    }

    function deleteAddress(bytes32 key) public {
        delete s_addressStorage[key];
    }

    function deleteBool(bytes32 key) public {
        delete s_boolStorage[key];
    }

    function deleteBytes(bytes32 key) public {
        delete s_bytesStorage[key];
    }

    function deleteString(bytes32 key) public {
        delete s_stringStorage[key];
    }

    function deleteInt(bytes32 key) public {
        delete s_intStorage[key];
    }

    function deleteBytes32(bytes32 key) public {
        delete s_bytes32Storage[key];
    }

    function deleteUintArray(bytes32 key) public {
        delete s_uintArrayStorage[key];
    }

    function deleteAddressArray(bytes32 key) public {
        delete s_addressArrayStorage[key];
    }

    function deleteBytesArray(bytes32 key) public {
        delete s_bytesArrayStorage[key];
    }
    // ... to continue ... Attention to deletion of complex types

    //         mapping(address => bool) public authorizedTokens;//bool storage
    //     mapping(uint256 => bool) public authorizedChains;// bool storage
    //  mapping(address => bool) public bridgedTokens;
    //     address[] public bridgedTokensList;
    //       mapping(address tokenHere => mapping(uint256 chainId => address tokenThere)) public tokenMapping;
    //     address[] public tokensList;
    //     uint256[] public chainIdsList;

    // getter / setter of authorizedTokens using bool storage and key getter
    function getAuthorizedToken(address token) public view returns (bool) {
        return getBool(getKey("authorizedTokens", token));
    }

    function setAuthorizedToken(address token, bool value) public {
        setBool(getKey("authorizedTokens", token), value);
    }

    function deleteAuthorizedToken(address token) public {
        deleteBool(getKey("authorizedTokens", token));
    }
    // getter / setter of authorizedChains using bool storage and key getter

    function getAuthorizedChain(uint256 chainId) public view returns (bool) {
        return getBool(getKey("authorizedChains", chainId));
    }

    function setAuthorizedChain(uint256 chainId, bool value) public {
        setBool(getKey("authorizedChains", chainId), value);
    }

    function deleteAuthorizedChain(uint256 chainId) public {
        deleteBool(getKey("authorizedChains", chainId));
    }
    // getter / setter of bridgedTokens using bool storage and key getter

    function getBridgedToken(address token) public view returns (bool) {
        return getBool(getKey("bridgedTokens", token));
    }

    function setBridgedToken(address token, bool value) public {
        setBool(getKey("bridgedTokens", token), value);
    }

    function deleteBridgedToken(address token) public {
        deleteBool(getKey("bridgedTokens", token));
    }
    // getter / setter of bridgedTokensList using address storage and key getter
    // get all / get by index / add / remove

    function getBridgedTokenList() public view returns (address[] memory) {
        return getAddressArray(getKey("bridgedTokensList"));
    }

    function getBridgedTokenList(uint256 index) public view returns (address) {
        return getAddress(getKey("bridgedTokensList", index));
    }

    function addBridgedTokenList(address token) public {
        address[] storage list = s_addressArrayStorage[getKey("bridgedTokensList")];
        list.push(token);
    }

    function removeBridgedTokenList(address token) public {
        address[] storage list = s_addressArrayStorage[getKey("bridgedTokensList")];
        for (uint256 i = 0; i < list.length; i++) {
            if (list[i] == token) {
                list[i] = list[list.length - 1];
                list.pop();
                break;
            }
        }
    }
    // getter / setter of tokenLists using address storage and key getter
    // get all / get by index / add / remove

    function getTokenList() public view returns (address[] memory) {
        return getAddressArray(getKey("tokensList"));
    }

    function getTokenList(uint256 index) public view returns (address) {
        return getAddress(getKey("tokensList", index));
    }

    function addTokenList(address token) public {
        address[] storage list = s_addressArrayStorage[getKey("tokensList")];
        list.push(token);
    }

    function removeTokenList(address token) public {
        address[] storage list = s_addressArrayStorage[getKey("tokensList")];
        for (uint256 i = 0; i < list.length; i++) {
            if (list[i] == token) {
                list[i] = list[list.length - 1];
                list.pop();
                break;
            }
        }
    }
    // getter / setter of chainIdsList using uint storage and key getter
    // get all / get by index / add / remove

    function getChainIdsList() public view returns (uint256[] memory) {
        return getUintArray(getKey("chainIdsList"));
    }

    function getChainIdsList(uint256 index) public view returns (uint256) {
        return getUint(getKey("chainIdsList", index));
    }

    function addChainIdsList(uint256 chainId) public {
        uint256[] storage list = s_uintArrayStorage[getKey("chainIdsList")];
        list.push(chainId);
    }

    function removeChainIdsList(uint256 chainId) public {
        uint256[] storage list = s_uintArrayStorage[getKey("chainIdsList")];
        for (uint256 i = 0; i < list.length; i++) {
            if (list[i] == chainId) {
                list[i] = list[list.length - 1];
                list.pop();
                break;
            }
        }
    }
    // getter / setter of birdegTokenToChainID using address storage and key getter
    //get / set // delete / add / remove

    function getBridgedTokenToChainId(address token) public view returns (uint256) {
        return getUint(getKey("bridgedTokenToChainId", token));
    }

    function setBridgedTokenToChainId(address token, uint256 chainId) public {
        setUint(getKey("bridgedTokenToChainId", token), chainId);
    }

    function deleteBridgedTokenToChainId(address token) public {
        deleteUint(getKey("bridgedTokenToChainId", token));
    }

    // @todo
    // ATTENTION add(0) => native token here
    // tokenMapped = add(0) => native token on chainId
    // by default Add are 0 so change this to Maxaddress for native tokens
    // and convert

    // getter / setter of tokensMapping using address storage and key getter
    // RENAME!!
    function getTokenOnChainId(address tokenAddress, uint256 chainId) public view returns (address) {
        return tokensMapping[tokenAddress][chainId];
    }

    function setTokenOnChainId(address tokenAddress, uint256 chainId, address tokenAddressOnChainId) public {
        tokensMapping[tokenAddress][chainId] = tokenAddressOnChainId;
    }

    // @todo
    // At the moment only one admin, relayer, oracle (server), factory, vault, etc.
    // later refactor to have array of relayers, orcales, etc.
    // and refactor to have access control for admin, relayer, oracle, etc. (via openzeppelin access control)

    // @todo ENUM of role for admin, relayer, oracle, factory, vault, etc.

    // update functions to change the address of the admin, relayer, oracle, factory, vault, etc.
    function updateOperator(string memory role, address newOperator) public {
        setAddress(getKey(role), newOperator);
    }
    // function updateAdmin(address newAdmin) public {
    //     setAddress(getKey("admin"), newAdmin);
    // }
    // getters

    function getOperator(string memory role) public view returns (address) {
        return getAddress(getKey(role));
    }
    // function getAdmin() public view returns (address) {
    //     return getAddress(getKey("admin"));
    // }

    // chekc if address is admin, relayer, oracle, factory, vault, etc.

    function isAdmin(address addr) public view returns (bool) {
        return getOperator("admin") == addr;
    }

    function isRelayer(address addr) public view returns (bool) {
        return getOperator("relayer") == addr;
    }

    function isOracle(address addr) public view returns (bool) {
        return getOperator("oracle") == addr;
    }

    function isBridge(address addr) public view returns (bool) {
        return getOperator("bridge") == addr;
    }

    function isFactory(address addr) public view returns (bool) {
        return getOperator("factory") == addr;
    }

    function isVault(address addr) public view returns (bool) {
        return getOperator("vault") == addr;
    }
}
