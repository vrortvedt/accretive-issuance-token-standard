# Avoiding Common Attacks

## Over/underflows
* SafeMath library

## Re-entrancy
* Use someAddress.send and someAddress.transfer which are limited to 2,300 gas on the called contract (only enough to log and event) to avoid re-entrancy

## Front-running / Race conditions
* Award delay - groups could provide that tokens only be awarded after some threshold number of blocks (e.g. 20 blocks or 5 minutes) following the completion of the issuance event to avoid potential front-running based on the award info and also to provide some period for appeal of a potentially incorrect award
