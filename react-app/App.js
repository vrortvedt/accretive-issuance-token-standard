import React, { Component } from 'react';
import './App.css';
import web3 from './web3';
import AUTRaffle from './AUTRaffle';
import { address } from './AUTRaffle';


class App extends Component {
  state = {
    owner: '',
    participants: [],
    winner: '',
    totalSupply: '',
    opened: '',
    message: '',
    ownerBalance: '',
    accounts: '',
    user: '',
    userBalance: ''
  };

  async componentDidMount() {
    const owner = await AUTRaffle.methods.owner().call();
    const participants = await AUTRaffle.methods.getParticipants().call();
    const winner = await AUTRaffle.methods.winner().call();
    const totalSupply = await AUTRaffle.methods.totalSupply().call();
    const status = await AUTRaffle.methods.eventStatus().call(); 
    const ownerBalance = await AUTRaffle.methods.balanceOf(owner).call();
    const accounts = await web3.eth.getAccounts();
    const user = await web3.eth.getAccounts();
    const userBalance = await AUTRaffle.methods.balanceOf(accounts[0]).call();

    if(status) {
      this.setState({ opened: "Open" }); 
    } else this.setState({ opened: "Closed" });

    this.setState({ owner, participants, winner, totalSupply, ownerBalance, accounts, user, userBalance });
  };

  onOpenClick = async (event) => {
    event.preventDefault();
    const accounts = await web3.eth.getAccounts();
    this.setState({ message: 'Opening a new raffle...' });
    await AUTRaffle.methods.openEvent().send({
      from: accounts[0]
    });

    this.setState({ message: 'The raffle is now open for entry!' });
    this.setState({ opened: "Open" });
  };

  onEnterClick = async (event) => {
    event.preventDefault();
    const accounts = await web3.eth.getAccounts();
    this.setState({ message: 'Entering raffle...' });
    await AUTRaffle.methods.enter().send({from: accounts[0] });
    this.setState({ message: 'You have been entered!' });
  };

  onPickWinnerClick = async (event) => {
    event.preventDefault();
    const accounts = await web3.eth.getAccounts();
    this.setState({ message: 'Picking the raffle winner...' });
    await AUTRaffle.methods.pickWinner().send({
      from: accounts[0]
    });
    this.setState({ message: 'A winner has been picked!' });
    this.setState({ opened: 'Closed' });
  };

  onCheckBalClick = async (event) => {
    event.preventDefault();
    const bal = await AUTRaffle.methods.balanceOf().call();
    this.setState({ userBalance: bal });
  };


  render() { 
    return (
      <div>
        <h2>Accretive Utility Token Demo - Raffle Contract</h2>
        <hr />
        <p> This is a demonstration of the use of the Accretive Utility Token (AUT) issuance standard for Ethereum ERC20-compatible tokens, which is described in more detail <a href="https://github.com/vrortvedt/accretive-issuance-token-standard/blob/master/README.md">here</a>. The rationale for the AUT model is that it incentivizes developers of utility-type tokens to create
        truly useful Dapps because they are rewarded in proportion to the utility of the Dapp.</p>
        <p> A simple raffle use case is deployed here.  Raffle participants mint RaffleTokens (RFT) when they enter the raffle.  The raffle winner receives 7/8ths of the newly minted tokens from that raffle, 
        while the developer who deployed the contract receives 1/8th of the newly minted tokens.</p> 
        <hr />
        <p>This contract was deployed at: <i>{address}</i></p>
        <p>It is owned by: <i>{this.state.owner}</i></p>
        <p>Your address: <i>{this.state.user}</i> </p>
        <p>Your RFT balance: {this.state.userBalance/1000000} </p>
        <p>Owner's RFT balance: {this.state.ownerBalance/1000000} </p>
        <p> A total of {this.state.totalSupply/1000000} RFT tokens have been created from this contract. </p>
        <p>Raffle Status: <b>{this.state.opened}</b></p>
        <hr />
          <h4>OWNER ACTIONS 
              <button onClick={this.onOpenClick}>New Raffle</button>  
              <button onClick={this.onPickWinnerClick}>Pick Winner</button></h4>
          <h4>NON-OWNER ACTIONS   
            <button onClick={this.onEnterClick}>Enter the Raffle</button> </h4>
           <hr />
        <h3>{this.state.message}</h3>
        <p>There are currently {this.state.participants.length} people entered competing to win {((this.state.participants.length)/8)*7} RaffleTokens.</p>
        <p>The contract owner will receive {((this.state.participants.length)/8)*1} RaffleTokens.</p>
        <p> The most recent winner was: {this.state.winner} </p>
 
        </div>
    );
  }
}

export default App;
