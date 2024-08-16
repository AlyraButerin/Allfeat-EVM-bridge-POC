const hre = require("hardhat");

// @todo move functions in appropriate helper

// @todo change allfeat for harmony (testnet) and add real allfeat chainId
const networkParams = {
  localhost: {
    chainId: 31337,
    nativeToken: { name: "ethereum", symbol: "ETH" },
    deployedTokens: [{ name: "mockedDai", symbol: "DAI" }],
  },
  hardhat: {
    chainId: 31337,
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
  allfeatLocal: {
    chainId: 440,
    nativeToken: { name: "allfeat", symbol: "AFT" },
    deployedTokens: [],
  },
  harmonie: {
    chainId: 441,
    nativeToken: { name: "allfeat", symbol: "AFT" },
    deployedTokens: [],
  },
  // @todo CHANGE NAME IN SCRIPT tp harmonie testnet and get real mainnet id
  allfeat: {
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
// to complete
const tokenSymbols = {
  ethereum: "ETH",
  allfeat: "AFT",
  dai: "DAI",
};

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

const tokenList = [
  {
    tokenName: "ethereum",
    symbols: [
      { chainId: 1, symbol: "ETH" },
      { chainId: 137, symbol: "ETH" },
      { chainId: 441, symbol: "abETH" },
      { chainId: 31337, symbol: "ETH" },
      { chainId: 11155111, symbol: "ETH" },
    ],
  },
  {
    tokenName: "dai",
    symbols: [
      { chainId: 1, symbol: "DAI" },
      { chainId: 137, symbol: "DAI" },
      { chainId: 441, symbol: "abDAI" },
      { chainId: 31337, symbol: "DAI" },
      { chainId: 11155111, symbol: "DAI" },
    ],
  },
  {
    tokenName: "allfeat",
    symbols: [
      { chainId: 1, symbol: "ebAFT" },
      { chainId: 137, symbol: "pbAFT" },
      { chainId: 441, symbol: "AFT" },
      { chainId: 31337, symbol: "hbAFT" },
      { chainId: 11155111, symbol: "sbAFT" },
    ],
  },
];

const getChainIdByNetworkName = (name) => {
  return networkParams[name].chainId;
};

const getNetworkNameByChainId = (chainId) => {
  const networkEntry = Object.entries(networkParams).find(
    ([network, params]) => params.chainId === chainId
  );
  return networkEntry ? networkEntry[0] : null;
};

const computeTokenSymbol = (network, symbol) => {
  // nbSSS => n for network, b for bridge, SSS for symbol
  const firstLetter = network.charAt(0).toLowerCase();
  return `${firstLetter}b${symbol}`;
};

const getContext = async () => {
  const network = hre.network.name;
  return {
    network,
    chainId: networkParams[network].chainId,
    nativeTokenName: networkParams[network].nativeToken.name,
    nativeTokenSymbol: networkParams[network].nativeToken.symbol,
    accounts: await hre.ethers.getSigners(),
  };
};

module.exports = {
  networkParams,
  tokenList,
  getChainIdByNetworkName,
  getNetworkNameByChainId,
  computeTokenSymbol,
  // usedNetworks,
  // usedTokens,
  tokenSymbols,
  tokenParams,
  getContext,
};
