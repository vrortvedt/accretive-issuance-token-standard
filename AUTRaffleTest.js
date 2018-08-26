const AUTRaffle = artifacts.require("./AUTRaffle.sol");
const assert = require('assert');


contract('Accretive Utility Token - Raffle Contract', (accounts) => {
    
    let raffle;
    const owner = accounts[0];
    const nonOwner1 = accounts[1];
    const nonOwner2 = accounts[2];
    
    beforeEach(async () => {
        raffle = await AUTRaffle.new();
    });
    
    // checks whether the AUTRaffle.sol contract instance was deployed
    it('deploys a contract', async () => {
        console.log("contract address is " + raffle.address);
        console.log("owner is " + owner);
        console.log("nonOwner1 is " + nonOwner1);
        console.log("nonOwner2 is " + nonOwner2);
        let owneraddress = await raffle.owner();
        assert.ok(owneraddress);
    });

    it('sets the expected address[0] as owner', async () => {
        assert.equal(await raffle.owner.call(), owner);
    });

    // checks whether an address that deployed the contract can open a raffle event
    it('allows owner to open a raffle', async () => {
        await raffle.openEvent({ from: owner });
        assert.ok(await !!raffle.eventStatus());
    });

    // checks whether an address that DID NOT deploy the contract can open a raffle event
    it('does not allow non-owner to open a raffle', async () => {
        try {
            await raffle.openEvent({ from: nonOwner1 });
        assert(false);
            } catch (err) {
        assert(err);
            }
        });

    // has the owner open a raffle and checks whether a non-owner address can enter
    it('allows a non-owner address to enter an opened raffle', async () => {
        await raffle.openEvent({
            from: owner,
        });
        await raffle.enter({
            from: nonOwner1,
        });
        const participants = await raffle.getParticipants();
        assert.equal(participants.length, 1);
    });

    // has the owner open a raffle and confirms that the owner cannot enter
    it('prevents the owner from entering an opened raffle', async () => {
        try {
            await raffle.openEvent({
                from: owner,
            });
            await raffle.methods.enter({
                from: owner,
            });
        assert(false);
            } catch (err) {
        assert(err);
            }
    });

    // has the owner open a raffle, has two non-owner addresses enter, and checks
    // whether the owner can pick a raffle winner 
    it('allows the owner to pick a winner from two entrants', async () => {
        await raffle.openEvent({ from: owner });
        await raffle.enter({ from: nonOwner1 });
        await raffle.enter({ from: nonOwner2 });
        let participants = await raffle.getParticipants();
        assert.equal(participants.length, 2);
        await raffle.pickWinner({ from: owner });
        participants = await raffle.getParticipants();
        assert.equal(participants.length, 0);
        const winner = await raffle.winner();
        assert.ok(winner !== undefined);
    });

    // has the owner open a raffle, has ONE non-owner addresses enter, and confirms
    // that the owner CANNOT pick a raffle winner 
    it('prevents the owner from picking a winner with one entrant', async () => {
        try {
            await raffle.openEvent({
                from: owner,
                gas: '1000000',
            });
            await raffle.methods.enter({
                from: nonOwner1,
            });
            await raffle.pickWinner({
                from: owner,
                gas: '1000000',
            });
        assert(false);
            } catch (err) {
        assert(err);
            }
    });

    // confirms that a non-owner may not pick the winner
    it('prevents non-owner addresses from picking winner', async () => {
        try {
            await raffle.openEvent({
                from: owner,
                gas: '1000000',
            });
            await raffle.enter({
                from: nonOwner1,
            });
            await raffle.enter({
                from: nonOwner2,
            });
            await raffle.pickWinner({
                from: nonOwner1,
                gas: '1000000',
            });
        assert(false);
        } catch (err) {
            assert(err);
        }
    });

    // has the owner pick a valid raffle winner and then checks whether the winner received
    // 7/8ths of the newly minted raffle tokens
    it('transfers 7/8ths of the raffle tokens to the raffle winner', async () => {
        await raffle.openEvent({ from: owner });
        await raffle.enter({ from: nonOwner1 });
        await raffle.enter({ from: nonOwner2 });
        await raffle.pickWinner({ from: owner });
        const winner = await raffle.winner();
        const mintedTokens = await raffle.totalSupply();
        const winnerBalance = await raffle.balanceOf(winner);
        assert.equal(winnerBalance, (mintedTokens/8) * 7);
    });
    
    // has the owner pick a valid raffle winner and then checks whether the owner received
    // 1/8th of the newly minted raffle tokens
    it('transfers 1/8th of the raffle tokens to the owner', async () => {
        await raffle.openEvent({ from: owner });
        await raffle.enter({ from: nonOwner1 });
        await raffle.enter({ from: nonOwner2 });
        await raffle.pickWinner({ from: owner });
        const mintedTokens = await raffle.totalSupply();
        const ownerBalance = await raffle.balanceOf(owner);
        assert.equal(ownerBalance, (mintedTokens/8) * 1);
    });
});
