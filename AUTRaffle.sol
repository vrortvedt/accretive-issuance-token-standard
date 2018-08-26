pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";

// This contract relies on a tweaked version of the OpenZeppelin library 
// "StandardToken.sol" by modifying the mapping "balances" and the 
// global variable "totalSupply" have been set to public from private 
// so that they can be viewed and called outside the contract.  


contract StandardTokenTweaked is ERC20 {
  using SafeMath for uint256;

  mapping (address => uint256) public balances;

  mapping (address => mapping (address => uint256)) private allowed;

  uint256 public totalSupply_;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_value <= balances[msg.sender]);
    require(_to != address(0));

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    require(_to != address(0));

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue >= oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Internal function that mints an amount of the token and assigns it to
   * an account. This encapsulates the modification of balances such that the
   * proper events are emitted.
   * @param _account The account that will receive the created tokens.
   * @param _amount The amount that will be created.
   */
  function _mint(address _account, uint256 _amount) internal {
    require(_account != 0);
    totalSupply_ = totalSupply_.add(_amount);
    balances[_account] = balances[_account].add(_amount);
    emit Transfer(address(0), _account, _amount);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account.
   * @param _account The account whose tokens will be burnt.
   * @param _amount The amount that will be burnt.
   */
  function _burn(address _account, uint256 _amount) internal {
    require(_account != 0);
    require(_amount <= balances[_account]);

    totalSupply_ = totalSupply_.sub(_amount);
    balances[_account] = balances[_account].sub(_amount);
    emit Transfer(_account, address(0), _amount);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account, deducting from the sender's allowance for said account. Uses the
   * internal _burn function.
   * @param _account The account whose tokens will be burnt.
   * @param _amount The amount that will be burnt.
   */
  function _burnFrom(address _account, uint256 _amount) internal {
    require(_amount <= allowed[_account][msg.sender]);

    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
    // this function needs to emit an event with the updated approval.
    allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
    _burn(_account, _amount);
  }
}

/**
 * @title Accretive Utility Token Raffle Contract
 *
 * @dev Implementation of the accretive utility token issuance model with a simple raffle
 */
contract AUTRaffle is StandardTokenTweaked, Ownable, Pausable {
    event Award(address indexed toWinner, address indexed toDevs, uint256 amount);
    event OpenEvent(address indexed ownerAddress);
    event Entered(address indexed entrantAddress);

    struct Event {
        uint eventCount;
        address[] participants;
        uint mintedTokens;
        uint eventWinnerIndex;
        bool open;
    }

    string public name = "RaffleToken";
    string public symbol = "RFT";
    uint8 public decimals = 6;
    uint public INITIAL_SUPPLY = 0;
    address public owner;
    address public winner;
    
    Event public events;

    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[owner] = INITIAL_SUPPLY;
        owner = msg.sender;
        events.open = false;
        events.eventCount = 0;
    }

    function award(address _toWinner, uint256 _amount) private onlyOwner whenNotPaused returns (bool) {
        totalSupply_ = totalSupply_.add(_amount);
        uint256 winnerShare = (_amount / 8) * 7;
        uint256 devsShare = (_amount / 8) * 1;
    
        balances[_toWinner] = balances[_toWinner].add(winnerShare);
        balances[owner] = balances[owner].add(devsShare);
    
        emit Award(_toWinner, owner, _amount);
        emit Transfer(address(0), _toWinner, winnerShare);
        emit Transfer(address(0), owner, devsShare);
        return true;
    }

    function openEvent() public onlyOwner whenNotPaused {
        require(!events.open);
        events.open = true;
        events.eventCount = events.eventCount + 1;
        emit OpenEvent(msg.sender);
    }
    
    function enter() external payable whenNotPaused {
        require(events.open);
        require(msg.sender != owner);
        require(canEnter());
        events.participants.push(msg.sender);
        emit Entered(msg.sender);
    }

    function pickWinner() public onlyOwner whenNotPaused {
        require(events.participants.length > 1);
        require(events.open);
        events.open = false; 
        events.eventWinnerIndex = pseudoRandom() % events.participants.length;
        events.mintedTokens = events.participants.length * 1000000;
        winner = events.participants[events.eventWinnerIndex];
        award(winner, events.mintedTokens);
        delete events.participants;
    }
    
    function pseudoRandom() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, events.participants[0]));
    }

    function getParticipants() public view returns (address[]) {
        return events.participants;
    }
    
    function eventStatus() public view returns (bool) {
        return events.open;
    }

    function canEnter() public view returns (bool) {
        for(uint i = 0; i < events.participants.length; i++) {
            require(events.participants[i] != msg.sender);
        }
        return true;
    }
}
