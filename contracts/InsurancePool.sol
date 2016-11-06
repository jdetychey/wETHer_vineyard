pragma solidity ^0.4.0;
import "https://github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";
import "InsurancePolicy.sol";
import "InsuranceQuote.sol";
import "InsuranceLib.sol";


contract InsurancePool is usingOraclize {
    using InsuranceLib for *;
    
    /* FIELDS */
    
    mapping(address => address) public quotes;
    mapping(address => address) public insurees;
    mapping(address => uint) public balanceOf;
    
    uint fee;
    uint minimum;
    
    uint public pool;
    uint public drops;
    
    address admin;
    
    /* MODIFIERS */
    
    modifier onlyAdmin {
        if(msg.sender != admin) throw;
        _;
    }
    
    modifier minimumLiquidity {
        if(pool < minimum) throw;
        _;
    }
    
    /* CONSTRUCTOR */
    
    function InsurancePool(uint _supply, uint _fee, uint _minimum) {
        
        OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
        
        drops = _supply;
        balanceOf[this] = drops;
        admin = msg.sender;
        fee = _fee;
        minimum = _minimum;
    }
    
    /* ADMIN METHODS */
    
    function setMinimum(uint _minimum) onlyAdmin {
        minimum = _minimum;
    }
    
    function setFee(uint _fee) onlyAdmin {
        fee = _fee;
    }
    
    function changeAdmin(address _admin) onlyAdmin {
        admin = _admin;
    }
    
    /* PROBABILITY METHODS */
    
    function setQuote(bytes32 _hash, string _url, bytes32 _latitude, bytes32 _longitude) returns(bool){
        address _quote = new InsuranceQuote(msg.sender, _hash, _url, _latitude, _latitude);
        if(_quote == address(0x0))
            return false;
        quotes[msg.sender] = _quote;
        return true;
    }
    
    function updateQuote(bytes32 _hash, string _url, bytes32 _latitude, bytes32 _longitude) constant returns(bool) {
        address q = quotes[msg.sender];
        if(!q.delegatecall(bytes4(sha3("getProbability(bytes32, string, bytes32, bytes32)")),_hash, _url, _latitude, _longitude)) {
            return false;
        }
        return true;
    }
    
    function getQuote() constant returns(uint) {
        address q = quotes[msg.sender];
        bytes32 _probability = bytes32(InsuranceQuote(q).probability());
        string memory probability = InsuranceLib.bytes32ToString(_probability);
        return usingOraclize.parseInt(probability);
    }
    
    
    /* INSURANCE POLICY METHODS */
    
    function createNewPolicy(bytes32 _hash,
                            string _url,
                            string _timeout, 
                            bool _position,
                            string _description) minimumLiquidity returns(address) {
        address q = quotes[msg.sender];
        bytes32 _latitude = bytes32(InsuranceQuote(q).latitude());
        bytes32 _longitude = bytes32(InsuranceQuote(q).longitude());
        uint _probability = getQuote();
        
        uint _coverage = InsuranceLib.calcCoverage(msg.value, fee, _probability);
        
        delete quotes[msg.sender];
        if(!q.delegatecall(bytes4(sha3("cancel()"))))
            throw;
            
        insurees[msg.sender] = new InsurancePolicy(msg.sender, _hash, _url, _latitude, _longitude, _timeout, 
                                                _position, _description);
        balanceOf[this] -= _coverage;
        pool -= _coverage;
        uint _total = (msg.value - fee) + _coverage;
        
        if(!insurees[msg.sender].send(_total))
            throw;
        
        
    }

    /* LIQUIDITY METHODS */
    
    function aquireDrops(uint _amount) returns(bool) {
        if(pool < 100 ether && balanceOf[this] > _amount) {
            balanceOf[this] -= _amount;
            balanceOf[msg.sender] += _amount;
            return true;
        }
        return false;
    }
    
    function transferDrops(address _reciever, uint _amount) returns(bool) {
        if(balanceOf[msg.sender] > _amount) {
            balanceOf[msg.sender] -= _amount;
            balanceOf[_reciever] += _amount;
            return true;
        } else {
            return false;
        }
    }
    
    function() {
        pool += msg.value;
    }
    
}