# **Accretive Utility Token Issuance Model with Raffle Implementation**

## **Overview**
The project provides for the accretive minting and issuance of fungible utility tokens utilized by a dApp according to the dApp’s award system.  Instead of tokens being pre-mined (minting all token supply at the moment the token is created) or issued on a time-based automated schedule regardless of token demand or use (as in PoW or PoS block rewards), an accretive utility token issuance model accurately reflects the dApp’s utility while providing users a method to acquire tokens without regard to their economic power.  It also proposes a compensation framework (see The Developer’s Bit section) that is intended to equitably and transparently reward developers in direct proportion to the utility of their dApp.

## Supporting Documentation
The docs folder contains the following files:
* [design_pattern_decisions.md](https://github.com/vrortvedt/accretive-utility-token-issuance-standard-with-raffle-contract/blob/master/docs/design_pattern_decisions.md "Title")
* [avoiding_common_attacks.md](https://github.com/vrortvedt/accretive-utility-token-issuance-standard-with-raffle-contract/blob/master/docs/avoiding_common_attacks.md "Title")
* [deployed_addresses.txt](https://github.com/vrortvedt/accretive-utility-token-issuance-standard-with-raffle-contract/blob/master/docs/deployed_addresses.txt "Title")

## **How To Set Up**
### Prerequisites:
* Node
* NPM
* Truffle
* Ganache-cli
* web3
* Metamask
* dotenv
* truffle-hdwallet-provider

### Steps:
1. from the terminal, create a new directory for this project - eg `mkdir AUTRaffle`
2. from inside that directory, run `truffle init`
3. in the contracts folder, create a new file titled "AUTRaffle.sol" and copy the solidity code from this repository
4. in the migrations folder, create a new file titled "2_deploy_contracts.js" and the js code from this repository
4. in the test folder, create a new file titled "AUTRaffleTest.js" and copy the js code from this repository
4. replace the files "truffle.js" and "truffle-config.js" with the same named files in this repository, or simply edit your files to match the code here
5. install the OpenZeppelin libraries via `npm install -E openzeppelin-solidity`
6. run `ganache-cli -p 7545`
7. in a new terminal tab in the same directory, run `truffle compile`
8. run `truffle migrate` - copy the contract address
9. run `truffle test`
10. at the [Remix](https://remix.ethereum.org "Title") browser, copy the code from "FlattenedAUTRaffle.sol" into a new window
##### INTERACTION OPTION A: Injected web3
11. copy the seed words from ganache-cli into a new metamask account import
12. switch metamask to the custom RPC addres `http://127.0.0.1:7545`
13. from the "Run" tab in Remix, select Injected Web3 environment - it should then show the first account created by ganache-cli that should also be loaded in metamask (NOTE: to access accounts after the account at index [0], click create account in metamask - it should give you the next account created by ganache-cli)
14. below that, paste the contract address copied from running `truffle migrate` into the form and click "At Address" - this should generate a new Deplyed Contract of "AUTRaffle[contract address](blockchain)"
15. click the arrow to interact with the contract - to switch between metamask accounts, you may need to refresh the page and redirect to the deployed contract by repeating the step above
##### INTERACTION OPTION B: Javascript VM Option
11. using the javascript VM environment, Deploy a copy of AUTRaffle
12. open the instance that appears in "Deployed Contracts" below and interact with the contract to test its functions
##### INTERACTION OPTION C: Deployed Rinkeby Instance Option
11. obtain rinkeby testnet ether from a metamask address - you can get some [here](https://faucet.rinkeby.io "Title")
12. at the [Remix](https://remix.ethereum.org "Title") browser, switch to the injected web3 environment
13. under the "Run" tab, copy the following into the form and click the "At Address" blue button 
`0xCF1F697736eC8F723Fb526e0c3AA4B654C1A6443` - this is an instance of the contract that has been deployed to the Rinkeby testnet
14. open the instance that appears in "Deployed Contracts" below and interact with the contract to test its functions - feel free to send me an email at victorrortvedt@gmail.com if you'd like me to open a raffle or pick a winner
#### To deploy your own instance of the contract
1. install the solc compiler `npm install -g solc`
1. install truffle-hdwallet-provider `npm install truffle-hdwallet-provider`
2. create local copies of the following OpenZeppelin libraries in your contracts folder:
* [math/SafeMath.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol "Title") 
* [ownership/Ownable.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol "Title")  
* [lifecycle/Pausable.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol "Title")
* [token/ERC20/ERC20.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol "Title")
3. create a file in the root directory called "compile.js" and copy the js code from this repository
4. create a file in the root directory called "truffle.js" and copy the js code from this repository
4. create a file in the root directory called "deploy.js" and copy the js code from this repository
5. obtain an [Infura API](https://infura.io "Title") key 
6. create a ".env" file in the directory in which you should assign your Infura API key to INFURA_API_KEY and assign your 12 word seed from metamask to MNEMONIC
7. add .env to your .gitignore file and make sure that you keep this file secret
8. run `node compile.js`
8. sign in to metamask from the account that you wish to deploy an instance of the contract from
9. run `node deploy.js`
10. copy the deployed contract address and interact with an instance where you are the owner in the [Remix](https://remix.ethereum.org "Title") browser using metamask in the injected web3 environment
11. you may need to click the Metamask icon to open the signing window each time - you may also need to refresh the page if you wish to send transactions after switching between Metamask accounts
NOTE: because every completed raffle requires an owner and at least two entrants, you will need at least three Metamask accounts funded with Rinkeby test ether to fully interact with and test the contract

## **User Stories**
* A raffle organizer deploys the contract, becomes its owner via the constructor and sends a transaction via
the openEvent function to open a new raffle.
* Upon deployment, ERC20-compliant RaffleTokens (RFT) are instantiated with a totalSupply of 0
* Participants enter the raffle by sending a transaction via the "enter" function
* Once there are at least two entrants in the raffle, the owner can call "pickWinner" which pseudorandomly chooses a winner
of the raffle, closes the raffle to new entrants and clears the array of current entrants.
* At the moment that a winner is picked, 1 RFT is minted for each entrant, so a minimum of 2 RFT tokens per raffle.
* Also at that moment, the winner is transferred 7/8ths of the minted RFT, and the owner who deployed the contract is 
transferred 1/8th of the minted RFT
* Token balances are stored on the blockchain, and the owner may open a new raffle from the same deployed contract by repeating the first step.  

## **Library packages**
This contract uses the following OpenZeppelin libraries:
* [math/SafeMath.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol "Title") 
* [ownership/Ownable.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol "Title")  
* [lifecycle/Pausable.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol "Title")
* [token/ERC20/ERC20.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol "Title")


 
