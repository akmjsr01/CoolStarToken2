// Allows us to use ES6 in our migrations and tests.
require('babel-register')

// Edit truffle.config file should have settings to deploy the contract to the Rinkeby Public Network.
// Infura should be used in the truffle.config file for deployment to Rinkeby.
require('dotenv').config();

const MNEMONIC = process.env['MNEMONIC'];
console.log('MNEMONIC:', MNEMONIC);
const INFURA_KEY = process.env['INFURA_KEY'];
console.log('INFURA_KEY:', INFURA_KEY);

const HDWalletProvider = require('truffle-hdwallet-provider');

module.exports = {
  networks: {
    ganache: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*' // Match any network id
    },
    rinkeby: {
      provider: () => new HDWalletProvider(MNEMONIC, 'https://rinkeby.infura.io/v3/' + INFURA_KEY),
      network_id: '4',
      gas: 4500000, 
      gasPrice: 10000000000
    }
  }
};
