
require('dotenv').config();

const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledContract = require('./compile');

const provider = new HDWalletProvider(
    process.env.MNEMONIC,
    "https://rinkeby.infura.io/" + process.env.INFURA_API_KEY,
    1
);
const web3 = new Web3(provider);

let abi = compiledContract.contracts['AUTRaffle.sol:AUTRaffle'].interface;
let bytecode = '0x'+compiledContract.contracts['AUTRaffle.sol:AUTRaffle'].bytecode;

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();
    // console.log(accounts);
    console.log('Attempting to deploy from account', accounts[0]);
    const result = await new web3.eth.Contract(JSON.parse(abi))
        .deploy({ data: bytecode })
        .send({ gas: '4500000', from: accounts[0] });
    console.log('Contract deployed to', result.options.address);
};
deploy();
