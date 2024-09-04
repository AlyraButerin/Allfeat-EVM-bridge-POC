// networks used for deployments

const usedNetworks = ["allfeat", "localhost", "sepolia"];
// const usedNetworks = ["gethTestnet", "allfeatLocal"];

// const usedNetworks = ["allfeat", "sepolia"];

// native coins and tokens used (as mockedToken for test)
const usedTokens = ["ethereum", "allfeat", "mockedDai"];

const forkPorts = {
  harmonie: "8540",
  // @todo CHANGE NAME IN SCRIPT tp harmonie testnet and get real mainnet id
  allfeat: "8541",
  sepolia: "8544",
  mainnet: "8545",
  polygonAmoy: "8546",
  polygon: "8547",
  fantomTestnet: "8548",
  fantom: "8549",
};

module.exports = {
  usedNetworks,
  usedTokens,
  forkPorts,
};