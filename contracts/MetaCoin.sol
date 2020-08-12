pragma solidity >=0.4.25 <0.7.0;

import "./ConvertLib.sol";

contract MetaCoin {

	struct Location{
		string name;
        address Receiver;
		address PreviousLocationId;
        uint Timestamp;
		uint amount;
    }

	mapping(address=>string) getID;
	mapping(string=>Location) ID;
    mapping(uint=>Location) Trail;
	uint8 TrailCount=0;
    mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	
	constructor() public {
		balances[tx.origin] = 10000;
	}

	function sendCoin(address receiver, uint amount,string memory name,string memory id) public returns(bool sufficient) {
		Location memory newLocation;
        newLocation.Receiver = receiver;
        newLocation.Timestamp = now;
		newLocation.name = name;
		newLocation.amount = amount;
		getID[receiver] = id;
        if(TrailCount!=0)
        {
            newLocation.PreviousLocationId= Trail[TrailCount].Receiver;
        }
        Trail[TrailCount] = newLocation;
		ID[id] = Trail[TrailCount];
        TrailCount++;
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		emit Transfer(msg.sender, receiver, amount);
		return true;
	}

	function getInfoPrevious(address receiver) public view returns(string memory,uint,string memory){
		string storage id = getID[receiver];
		if (bytes(id).length == 0){
			return ("Null",0,id);
		}
		return (ID[id].name,ID[id].amount,id);
	}

	function getTransactionByID(string memory id) public view returns(uint,string memory,address) {
		
		return (ID[id].amount,ID[id].name,ID[id].Receiver);
	}

 	function GetTrailCount() public view returns(uint8){
        return MetaCoin.TrailCount;
    }

    function GetLocation(uint8 TrailNo) public view returns (string memory,uint,address)
    {
        return (Trail[TrailNo].name,Trail[TrailNo].amount,Trail[TrailNo].Receiver);
    }

	function getBalanceInEth(address addr) public view returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}

	function getBalance(address addr) public view returns(uint) {
		return balances[addr];
	}

	function getaddress() public view returns(address) {
		return msg.sender;
	}
	
}