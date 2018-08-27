
require('dotenv').config();
const HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      gas: 6500000,
      network_id: "5777"
    },
    rinkeby: {
    provider: new HDWalletProvider(process.env.MNEMONIC, "https://rinkeby.infura.io/" + process.env.INFURA_API_KEY),
    network_id: 4,
    gas: 4500000
	},
  }
};
