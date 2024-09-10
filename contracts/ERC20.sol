// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ERC20 {

//State variables 
    string public name;
    string public symbol;
    uint8  public decimals;
    uint256 public immutable totalSupply;

//Mappings
    mapping (address => uint256)  public _balances ;

    // The following mapping allows the user to create spender that can use a defined amount of their balance, 
    //imagine you want to borrow some money to ur friend but you don't want to share your private key since that will 
    // will give them legitimate access to your account, so in this can you give allowance to spend some amount of the given token that yourself you specified
    mapping (address => mapping(address => uint256)) public _allowance;

//Events
    event Transfer(address indexed _from,address _to,  uint256 value );
    event Approval(address indexed _owner,address _spender,  uint256 value );
     
 //Constructor
    constructor(string memory _name,string memory _symbol, uint256 _totalSupply,uint8 _decimals ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply =  _totalSupply;

        _balances[msg.sender] =  _totalSupply;
    }


    //Functions
    function transfer(address _to, uint256 _amount) external hasEnoughBalance(_amount) returns(bool) {
        _balances[msg.sender] -= _amount;
        _balances[_to] += _amount;

        emit Transfer(msg.sender,_to,_amount);
        return true;
    }

    function transferFrom(address from,address recipient, uint256 _amount) external returns(bool)  {
        require(_allowance[msg.sender][recipient] > _amount, 'No enough balance');
        _balances[from] -= _amount;
        _balances[recipient] += _amount; 

        _allowance[msg.sender][recipient] -= _amount;
        return true;
    }

    function balanceOf(address owner) public view  returns (uint256) {
        require(owner != address(0), 'Invalid address');
        return _balances[owner];
    }


    function approve(address spender,uint256 _amount) public hasEnoughBalance(_amount) returns(bool)   {
       _allowance[msg.sender][spender] = _amount;
       emit Approval(msg.sender,spender, _amount);
       return true;
    }

    modifier hasEnoughBalance(uint256 _amount) {
       require(_balances[msg.sender] > _amount ,'No enough balance.');
       _;
    }

    function allowence( address owner,address spender) public view returns(uint256) {
       return _allowance[owner][spender];
    }
}
