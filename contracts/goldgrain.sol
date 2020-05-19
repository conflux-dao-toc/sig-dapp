pragma solidity ^0.5.0;

contract Owned {

    address public owner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {

        owner = msg.sender;

    }

    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }

    function transferOwnership(address newOwner) public onlyOwner {

        owner = newOwner;

        emit OwnershipTransferred(owner, newOwner);

    }

}

contract goldgrain is Owned{
    
    address public winner;
    
    constructor() public {
       
    }
    
    function rand(uint256 _length) public view returns(uint256) {

        uint256 random = uint256(keccak256(abi.encodePacked(

                    (block.timestamp) +

                    (block.difficulty) +

                    (block.gaslimit) +

                    (block.number),now

                ))) % 1000000;

        return random % _length;

    }

    function getwinner() public view returns(address _winneraddress){
        
        return winner;
    }
    
    function () payable external{
        
        if(msg.value == 1 ether){
            
            uint256 random_num = rand(10000);
            
            if(random_num == 888){
                
                if(winner == address(0)){
                    
                    winner = msg.sender;
                    
                    msg.sender.transfer(666 ether);
                    
                }
                
            }
        }
        
    }
    
    function withdraw(uint _balance) payable external  onlyOwner{
        
        msg.sender.transfer(_balance);
    }
}