const AUTRaffle = artifacts.require("./AUTRaffle.sol");

module.exports = function(deployer) {
  deployer.deploy(AUTRaffle);
};
