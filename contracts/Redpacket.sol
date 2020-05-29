pragma solidity ^ 0.5.0;


library SafeMath {
  function add(uint a, uint b) internal pure returns(uint c) {
    c = a + b;
    require(c >= a);
  }
  function sub(uint a, uint b) internal pure returns(uint c) {
    require(b <= a);
    c = a - b;
  }
  function mul(uint a, uint b) internal pure returns(uint c) {
    c = a * b;
    require(a == 0 || c / a == b);
  }
  function div(uint a, uint b) internal pure returns(uint c) {
    require(b > 0);
    c = a / b;
  }
}


//使用CRC20标准
contract CRC20Interface {
  function totalSupply() public view returns(uint);
  function balanceOf(address tokenOwner) public view returns(uint balance);
  function allowance(address tokenOwner, address spender) public view returns(uint remaining);
  function transfer(address to, uint tokens) public returns(bool success);
  function approve(address spender, uint tokens) public returns(bool success);
  function transferFrom(address from, address to, uint tokens) public returns(bool success);
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// //合约owner
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


contract Redpacket is Owned{
    
    using SafeMath for uint;
    
    //Initial number of red packets
    uint redPacketNumber = 10;
    
    //Current red packet size
    uint redPacketSize ;
    
    // Current single red packet size
    uint singleRedPacketSize;
    
    CRC20Interface _fcContract;
    
    // Current red packet index
    uint index ;
    
    address[] addressArray;
    
    mapping(address => uint) addressmap;
    
  
     constructor(address _fcContractAddress) public {
         
        _fcContract = CRC20Interface(_fcContractAddress);
        
        index = 1;
        
    }
    
    
    function setPackeNumber(uint _newNumber) public onlyOwner returns(bool success){
        
        redPacketNumber = _newNumber;
        
        return true;
        
    }
    
    function  getRedPacketBalance() public view returns(uint _balance){
        
        return  _fcContract.balanceOf(address(this));
        
    }
    
    
    function  getRedPacketNumber() public view returns(uint _number){
        
        return  redPacketNumber;
        
    }
    
    
    function  getRedPacketSize() public view returns(uint _size){
        
        return  redPacketSize;
        
    }
    
    function  getSingleRedPacketSize() public view returns(uint _size){
        
        return  singleRedPacketSize;
        
    }
    
    function  getRedPacketIndex() public view returns(uint _index){
        
        return  index;
        
    }
    
    
    function transferAnyCRC20Token(address tokenAddress, address toAddress,uint tokens) public onlyOwner returns(bool success) {
        return CRC20Interface(tokenAddress).transfer(toAddress, tokens);
    }
    
    
    function () payable external{
        
        if(index == 1){
            
            uint _balance = _fcContract.balanceOf(address(this));
            
            redPacketSize = _balance;
                
            singleRedPacketSize = _balance.div(redPacketNumber);
            
            addressArray = new address[](redPacketNumber);
            
        }
        
        require(redPacketSize > 0);
        
        require(addressmap[msg.sender] == 0);
            
        _fcContract.transfer(msg.sender, singleRedPacketSize);
    
        addressArray[index-1] = msg.sender;
            
        addressmap[msg.sender] = singleRedPacketSize;
            
        
        if(index == redPacketNumber){
            
            index = 1;
            
            redPacketSize = 0;
            
            singleRedPacketSize = 0;
                
            for(uint i=0 ;i <addressArray.length ; i++){
                    
                delete addressmap[addressArray[i]];
            }
                
            delete addressArray;
            
        }else{
            
           index ++;
            
        }
            
       
      
        
    }
    
    
}
