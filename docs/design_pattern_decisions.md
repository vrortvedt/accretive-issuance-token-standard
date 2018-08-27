# Design Pattern Decisions

## Accretive Utility Token
The mechanics for accretive utility token issuance are built on the [ERC20 fungible token standard](https://theethereum.wiki/w/index.php/ERC20_Token_Standard "Title") and are straightforward:  
1. A developer creates a dApp-specific token and set its total supply to 0, and deploys a contract allowing for users to join competitive events
1. The developer opens an event within the dApp, users enter and compete, and when the event is over, the contract mints one token per eligible entrant
1. The winner or winners of the event are transferred 7/8ths of the newly-minted tokens while the dApp developers are transferred 1/8th of the new tokens
1. The token supply is incremented and new events may be opened

### Benefits of Accretive Issuance
One major advantage of the AUT issuance model is that the total token supply reflects the actual utility of the underlying dApp rather than serving as a barometer for the number of speculators who may not intend to use the dApp but rather are hoping to offload the tokens on others at a profit.  A poorly designed dApp with few actual users will be reflected in an anemic token supply with infrequent issuance events, whereas a popular dApp could be appropriately measured through the number of people actively using it and incrementing its token supply.  The token supply can serve as a signal to would-be users to help them discover actually useful dApps rather than all-hat-no-cattle (aka white paper vaporware) aspirational projects.

This issuance model also allows for nearly-free participation in award events that allows talented users to amass tokens regardless of their ability to pay.  To the extent a dapp seeks to entice high quality users rather than just those who have financial means to meaningfully participate, the AUT model would not discourage users who would otherwise feel excluded. 

Because this model would not allow tokens to be pre-sold as it requires a functioning dApp, and any value wrapped up in the tokens themselves would be created through the efforts of the users of the dApp rather than its developers, it would also appear to fail to meet the Howey test for US securities. 

### Developer’s Bit
Developers of utility dApps may choose to use an AUT issuance model that provides them with token rewards for building a useful dApp in direct proportion to the utility of their dApp.  The concept of the “developer’s bit” is proposed, whereby one-eighth (as there are eight bits in a byte) of the newly minted the developer-controlled address that created the AUT token.  This would align the developers’ interests in receiving a return on their labor with the users’ interests in utilizing fun and engaging decentralized applications.  In the presale/ICO model, developers may lose the incentive to deliver an excellent utility dApp after they have already reaped substantial gains before the product even exists.  In the scheduled-release PoW/PoS model, the total token supply would not signal the utility of the dApp token, only the amount of time that has elapsed since it was launched.

The goal is to create a compensation standard that is baked into the issuance mechanism and that satisfies the community's sense of fairness while appropriately incentivizing (that is, neither under- nor over-incentivizing) developers to create the most useful dApps.

### Limitation of one entry per eligible address
Of course, dApps or dApp users may attempt to game the AUT system through use of bots to artificially increase the total supply and give the false impression of utility.  Therefore an AUT issuance model should be coupled with certain identity verification protocols, such as through use of uPort DIDs and rewards for whistleblowers for the discovery of Potemkin accounts.  dApps may include their own award eligibility requirements, but a successful AUT issuance model would be built on a floor of identity verification techniques.

### Circuit breaker
The Pausable library is applied to allow the developers to halt an AUT contract that comes under attack.

## Raffle Implementation
This contract implements a simple raffle, whereby the owner who deployed the contract may open a raffle, after which time other users (excluding the owner) may enter the raffle paying only the gas costs to do so.  Once there are at least two raffle entrants, the owner may choose a winner through use of of a psuedorandom number generator.  Upon choosing a winner, one RaffleToken (RFT) is minted per entrant, and 7/8ths of those tokens are transferred to the winner, while the remaining 1/8th of the tokens go to the owner, here standing in for the developer. At that point the array of entrants is cleared and the owner may open another raffle.

#### Logical design constraints in the raffle contract
* Only the owner may open a new raffle when the contract is not paused
* Owners may not enter their own raffles
* Users may only enter a raffle once
* A raffle must have at least two entrants before a winner may be chosen
* Only the owner may pick a winner
* The winner is chosen pseudorandomly
* The number of tokens minted is equal to the number of raffle entrants
* Newly minted tokens are transferred automatically with 7/8ths to the raffle winner and 1/8th to the owner 

### Flexible standard to have broad application in utility dApps
I choose a raffle as a proof of concept of the AUT issuance model, but there are real applications for an AUT issuance model.  Any community of interest that can compete over the internet may make use of AUT to establish reputational rank and to attract those with common interests to the same forum. 

Some AUT-based dApps might require entrants to evaluate their fellow entrants or perform some other legitimizing function in order to be eligible to win tokens.  For example, a haiku competition might require entrants to rank 6 other randomly assigned submissions from best to worst by a deadline in order to be able to win.

It also would allows for the staking of earned tokens in high buy-in tournaments, which may appeal to successful competitors. 

Some dApps may wish to allow users to spend their tokens on digital bling for their profiles, or on exclusive features.

Exemplary potential use cases for AUT:
* e-sports
* weather forecasting or other prediction markets
* prompt-based joke competitions (eg caption contest, zingers about a particular headline)
* art or music submissions
* blockchain-based strategy games
