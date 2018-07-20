pragma solidity ^0.4.24;

contract AccretiveUtilityToken {

    bytes32 public name = "Accretive Utility Token";      //  token name
    bytes8 public symbol = "AUT";           //  token symbol
    uint256 public decimals = 18;            //  token digit

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    uint256 public totalSupply;
    address[] public participants;
    
    struct Participant {
        bool eligible;
        string submission;
        uint8[] evals;
    }
    
    mapping (address => Participant) public participantInfo;
    
    bool public stopped = false;

    address owner = 0x0;

    modifier isDev {
        assert(owner == msg.sender);
        _;
    }
    
     modifier isParticipant {
        assert(owner == msg.sender);
        _;
    }

    modifier isRunning {
        assert(!stopped);
        _;
    }

    modifier validAddress {
        assert(0x0 != msg.sender);
        _;
    }

    constructor(address _tokenCreator) public {
        owner = msg.sender;
        totalSupply = 0;
        balanceOf[_tokenCreator] = 0;
    }

    function createAwardEvent(uint256 _participants) public isDev {
        _participants = participants.length;
    }
    
    function participate(string _submission, uint8 _eval) public isParticipant {
        participantInfo[msg.sender].eligible = false;
        bytes memory emptySubmissionTest = bytes(_submission);
        require(emptySubmissionTest.length > 0 && _eval > 0);
        participantInfo[msg.sender].submission = _submission;
        participantInfo[msg.sender].evals = _eval;
        participantInfo[msg.sender].eligible = true;
    }
    
    function mintAndDistributeAUT(address _awardee, address _tokenCreator, uint256 _value) public payable isDev {
        participants.length = _value;
        totalSupply = totalSupply + _value;
        balanceOf[_awardee] += _value / 8 * 7;
        balanceOf[_tokenCreator] += _value / 8 * 1;
    }
    
    function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        require(allowance[_from][msg.sender] >= _value);
        balanceOf[_to] += _value;
        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
        require(_value == 0 || allowance[msg.sender][_spender] == 0);
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function stop() public isDev {
        stopped = true;
    }

    function start() public isDev {
        stopped = false;
    }

    function setName(bytes32 _name) public isDev {
        name = _name;
    }

    function burn(uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[0x0] += _value;
        emit Transfer(msg.sender, 0x0, _value);
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
