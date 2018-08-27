module.exports = {
  rinkeby: {
    host: "localhost", // Connect to geth on the specified
    port: 8545,
    from: "0x7f7dc314fc75658d474dbbfe598ebb058ca6aacd", // default address to use for any transaction Truffle makes during migrations
    network_id: 4,
    gas: 4612388 
  },
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    }
  }
};
