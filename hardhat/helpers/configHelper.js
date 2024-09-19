///////////////////////////////////////////////////////////////////////////////
//
//                DESCRIPTION OF NETWORKS: chainId, native token info, deployed tokens
//
///////////////////////////////////////////////////////////////////////////////

// @todo RENAMING nativeToken => nativeCoin or Currency, Asset
// @todo RENAMING in scripts allfeat => harmonie
// @todo choose a convention for naming/network: duplicates!!

/**
 * @dev Description of network configuration and deployed tokens
 */
const networkParams = {
  localhost: {
    chainId: 31337,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [{ name: "mockedDai", symbol: "DAI" }],
  },
  hardhat: {
    // to complete (used for forks)
    chainId: 31337,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [{ name: "mockedDai", symbol: "DAI" }],
  },
  anvil_local: {
    chainId: 31337,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [{ name: "mockedDai", symbol: "DAI" }],
  },
  geth: {
    chainId: 1337,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [{ name: "mockedDai", symbol: "DAI" }],
  },
  gethTestnet: {
    chainId: 1337,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [{ name: "mockedDai", symbol: "DAI" }],
  },
  sepolia: {
    chainId: 11155111,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [{ name: "mockedDai", symbol: "DAI" }],
  },
  ethereum: {
    chainId: 1,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [{ name: "dai", symbol: "DAI" }],
  },
  allfeat_local: {
    chainId: 440,
    nativeToken: { name: "allfeat", symbol: "AFT" },
    deployedTokens: [],
  },
  allfeatLocal: {
    chainId: 440,
    nativeToken: { name: "allfeat", symbol: "AFT" },
    deployedTokens: [],
  },
  // harmonie: {
  //   chainId: 441,
  //   nativeToken: { name: "harmonie", symbol: "HMY" },
  //   deployedTokens: [],
  // },
  allfeat: {
    // current harmonie testnet
    chainId: 441,
    nativeToken: { name: "allfeat", symbol: "AFT" },
    deployedTokens: [],
  },
  polygonAmoy: {
    chainId: 80002,
    nativeToken: { name: "matic", symbol: "MATIC" },
    deployedTokens: [],
  },
  polygon: {
    chainId: 137,
    nativeToken: { name: "matic", symbol: "MATIC" },
    deployedTokens: [],
  },
  fantomTestnet: {
    chainId: 4002,
    nativeToken: { name: "fantom", symbol: "FTM" },
    deployedTokens: [],
  },
  fantom: {
    chainId: 250,
    nativeToken: { name: "fantom", symbol: "FTM" },
    deployedTokens: [],
  },
  bscTestnet: {
    chainId: 97,
    nativeToken: { name: "binance", symbol: "BNB" },
    deployedTokens: [],
  },
  bsc: {
    chainId: 56,
    nativeToken: { name: "binance", symbol: "BNB" },
    deployedTokens: [],
  },
  arbitrumSepolia: {
    chainId: 421614,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [],
  },
  arbitrum: {
    chainId: 42161,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [],
  },
  optimismSepolia: {
    chainId: 11155420,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [],
  },
  optimism: {
    chainId: 10,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [],
  },
};

///////////////////////////////////////////////////////////////////////////////
//
//                DESCRIPTION OF TOKENS
//
///////////////////////////////////////////////////////////////////////////////
/**
 * @dev For each token give its description, if it's a native coin and
 * which chain is its origin chain
 */
const tokenParams = {
  ethereum: {
    tokenName: "ethereum",
    tokenSymbol: "ETH",
    originChainId: [1, 31337, 11155111],
    isNative: true,
  },
  allfeat: {
    tokenName: "allfeat",
    tokenSymbol: "AFT",
    originChainId: [441],
    isNative: true,
  },
  matic: {
    tokenName: "matic",
    tokenSymbol: "MATIC",
    originChainId: [137],
    isNative: true,
  },
  dai: {
    tokenName: "dai",
    tokenSymbol: "DAI",
    originChainId: [1],
    isNative: false,
  },
  mockedDai: {
    tokenName: "mockedDai",
    tokenSymbol: "DAI",
    originChainId: [31337, 11155111],
    isNative: false,
  },
};

///////////////////////////////////////////////////////////////////////////////
//
//                NETWORK HELPERS
//
///////////////////////////////////////////////////////////////////////////////

const getChainIdByNetworkName = (name) => {
  return networkParams[name].chainId;
};

const getNetworkNameByChainId = (chainId) => {
  const networkEntry = Object.entries(networkParams).find(
    ([network, params]) => params.chainId === chainId
  );
  return networkEntry ? networkEntry[0] : null;
};

///////////////////////////////////////////////////////////////////////////////
//
//                SYMBOL HELPERS
//
///////////////////////////////////////////////////////////////////////////////

const computeTokenSymbol = (network, symbol) => {
  // nbSSS => n for network, b for bridge, SSS for symbol
  const firstLetter = network.charAt(0).toLowerCase();
  return `${firstLetter}b${symbol}`;
};

////////////////////////////////////////////////////////////////
//
//             FEES CONSTANTS
//
///////////////////////////////////////////////////////////////
const FEES_AMOUNT = 1_000_000_000_000_000n; //0.001

////////////////////////////////////////////////////////////////
//
//             AS_CLI HELPERS
//
///////////////////////////////////////////////////////////////
// @todo remove if we don't keep cli
// moved from constants/token.js to reduce files numbers

const nativeTokens = {
  31337: "ethereum",
  1337: "ethereum",
  440: "allfeat",
  11155111: "ethereum",
  441: "allfeat",
};

const getNativeToken = (chainId) => {
  try {
    return nativeTokens[chainId];
  } catch (err) {
    throw "Invalid chainId!";
  }
};

module.exports = {
  networkParams,
  getChainIdByNetworkName,
  getNetworkNameByChainId,
  computeTokenSymbol,
  tokenParams,
  FEES_AMOUNT,
  getNativeToken,
};
