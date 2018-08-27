const fs = require('fs');
const solc = require('solc');

const input = {
    'SafeMath.sol': fs.readFileSync('./contracts/SafeMath.sol', 'utf8'),
    'ERC20.sol': fs.readFileSync('./contracts/ERC20.sol', 'utf8'),
    'Pausable.sol': fs.readFileSync('./contracts/Pausable.sol', 'utf8'),
    'Ownable.sol': fs.readFileSync('./contracts/Ownable.sol', 'utf8'),
    'AUTRaffle.sol': fs.readFileSync('./contracts/AUTRaffle.sol', 'utf8')
};

let compiledContract = solc.compile({sources: input}, 1);

module.exports = compiledContract;
