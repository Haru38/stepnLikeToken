const fs = require("fs");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const network = "mumbai";
//const network = "mainnet";

const publicKey = fs
  .readFileSync("config/" + network + "/public_key.txt")
  .toString()
  .trim();
const privateKey = fs
  .readFileSync("config/" + network + "/private_key.txt")
  .toString()
  .trim();

const infuraPath = fs
  .readFileSync("config/" + network + "/infura_path.txt")
  .toString()
  .trim();

module.exports = {
  networks: {
    mumbai_infura: {
      provider: function () {
        return new HDWalletProvider(privateKey, infuraPath);
      },
      skipDryRun: true,
      confirmations: 1,

      network_id: 80001,
      gas: 5000000, // 5 m
      gasPrice: 10000000000, // 10 gwei
      from: publicKey,
    },
  },
  compilers: {
    solc: {
      version: "0.8.7",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
  },
};
