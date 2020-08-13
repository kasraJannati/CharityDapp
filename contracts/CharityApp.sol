pragma solidity >=0.4.21 <0.7.0;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public{
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract CharityApp is Ownable {
    
  address payable charity;
  uint256 public minAmount;
  address[] public donors;
 
 /* check the address and amount */
  modifier validateDonation(address _donor, uint256 _minAmount) {
    require(_donor != address(0));
    require(minAmount <= _minAmount);
    _;
  }
  
  event Donated(address indexed donor, uint256 amount);
  
  constructor(address payable _charity, uint256 _minAmount) public {
    require(_charity != address(0));
    require(_minAmount > 0);
    charity = _charity;
    minAmount = _minAmount;
  }

 /* if somebody sends money without any funcation, pays back the sender */


  receive() external payable{
      msg.sender.transfer(msg.value);
  }
  
  
  function donate(address _donor) public payable validateDonation(msg.sender, msg.value){
    charity.transfer(msg.value);
    donors.push(_donor);
    emit Donated(msg.sender, msg.value);
  }

}