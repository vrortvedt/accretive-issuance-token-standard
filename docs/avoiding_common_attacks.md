# Avoiding Common Attacks

## Logical flaws
* This contract has been unit tested to reduce logical flaws in its operation.  

## Use of proven libraries
* This contract relies on several ERC20 token related OpenZeppelin contracts which have been substantially tested for flaws, reducing the attack surface to the extent those libraries are secure.   

## Use of emergency stop
* This contract inherits the Pausable.sol library and implements its functions, allowing the owner to be able to halt the contract if an attack were detected

## Over/underflows
* This contract implements the OpenZeppelin SafeMath library to guard against integer underflows and overflows

## Poisoned user input
* This contract does not take any strings that could present attack vectors for malicious actors to overload

## Guessing timestamp-dependent pseudorandom numbers
* Because no one other than the owner of the contact can pick a raffle winner through psuedorandom number generation, and the timestamp is one of the elements hashed in that process, it is unlikely that any raffle entrant (an array that excludes the owner of the contract) could choose to participate in a raffle at a time that he or she is more likely to win

## Transaction-Ordering Dependence (TOD) / Front Running
* Because a new raffle cannot be opened unless the raffle status is set to closed, malicious miners could not amass a number of winning raffles before choosing to confirm only those with favorable outcomes from their perspective
