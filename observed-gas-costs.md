08-21-2018 Remix Web3 Provider deployment of AUT-raffle-project.sol to Ganache GUI v1.2.1, NodeJS v.8.11.2, OSX

Using gas price 1
Deployment of RaffleToken contract: 2,583,031 gas used
openEvent(account[0]): 68229 gas used
enter(account[1]): 63313 gas used
enter(account[2]): 49154 gas used
pickWinner(account[0]): 128,612 gas used but Remix terminal "errored: VM Excetion while processing transaction: out of gas" 

Using gas price 1
Deployment of AccretiveUtilityToken contract: 2,235,935 gas used
openEvent(account[0]): 68141 gas used
enter(account[1]): 63225 gas used
enter(account[2]): 49066 gas used
enter(account[3]): 49907 gas used
pickWinner(account[0]): 143,546 gas used but Remix terminal "errored: VM Excetion while processing transaction: out of gas"

---

08-21-2018 Remix Injected Web3 Ropsten deployment of AUT-raffle-project.sol OSX
Ropsten contract address: 0xf0C8566f7725A0C6e95a8e51018125618E635215
Gas limit: 3,000,000

Deployment of AccretiveUtilityToken contract: 1,056,901 gas used
openEvent(account[0]): 68127 gas used
enter(account[1]): 63141 gas used
enter(account[2]): 48979 gas used
pickWinner(account[0]): 143,089 gas used but tx failed Etherscan: "Warning! Error encountered during contract execution [Out of gas]"
Details of step by step execution at https://ropsten.etherscan.io/vmtrace?txhash=0x3db160f314406bb98f4b4e395ddca55e7e41c7c8ba615f19b7f2d4c7a0ed87a9
BUT tried it again with a 30,000,000 gas limit and success, with strangely the same amount of gas
pickWinner(account[0]): 128,089 gas used 

RaffleToken holders on Ropsten: https://ropsten.etherscan.io/token/0xf0c8566f7725a0c6e95a8e51018125618e635215#balances
