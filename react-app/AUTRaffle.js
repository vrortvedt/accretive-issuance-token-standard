import web3 from './web3';
import AUTRaffle from './AUTRaffle.json';

const address = '[PASTE DEPLOYED CONTRACT ADDRESS HERE AFTER RUNNING TRUFFLE MIGRATE --RESET]'; 
export { address };
console.log(AUTRaffle);
export default new web3.eth.Contract(AUTRaffle.abi, address);

