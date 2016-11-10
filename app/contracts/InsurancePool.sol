pragma solidity ^0.4.0;

import "InsuranceQuote.sol";
import "./lib/usingOraclize.sol";
import "./lib/InsuranceLib.sol";

contract InsurancePool is usingOraclize {
    using InsuranceLib for *;

    /* FIELDS */

    mapping(address => address) quotes;
    mapping(address => address) insurees;
    mapping(address => uint) balanceOf;

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

      OAR = OraclizeAddrResolverI(0x291d894f1c784011f3bf61f76b925ed40f007470);

        admin = msg.sender;
        drops = _supply;
        balanceOf[admin] = drops;
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

    function setQuote(bytes32 _hash, string _url, bytes32 _latitude, bytes32 _longitude) payable returns(address){
        InsuranceQuote _quote = new InsuranceQuote();
        if(_quote.send(1 ether))
        _quote.getProbability(_hash, _url, _latitude, _longitude, "1");
        /*if(_quote == address(0x0))
            return false;*/
        //quotes[msg.sender] = _quote;
        return _quote;
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
        bytes32 _probability = InsuranceQuote(q).probability();
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
        balanceOf[admin] -= _coverage;
        pool -= _coverage;
        uint _total = (msg.value - fee) + _coverage;

        if(!insurees[msg.sender].send(_total))
            throw;


    }


    /* LIQUIDITY METHODS */

    function aquireDrops(uint _amount) returns(bool) {
        if(pool < 100 ether && balanceOf[admin] > _amount) {
            balanceOf[admin] -= _amount;
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

contract InsurancePolicy is usingOraclize {

    uint public balance;

    address insuree;
    address public InsurancePool;

    bytes32 public latitude;
    bytes32 public longitude;

    uint public start;
    uint public timestamp;

    uint cycles;
    uint invariants;

    string public description;

    string public url;

    /* RESOLVER QUERY STRINGS */
    string constant prefix = "json(https://api.darksky.net/forecast/e5fa70950b02e623da2a1c7159f8ee93/";
    string constant suffix = ").daily.data[0].precipIntensityMax,precipType";


    bool public position;


    modifier onlyInsuree {
        if(msg.sender != insuree) throw;
        _;
    }

    function InsurancePolicy(address _insuree,
                    bytes32 _hash,
                    string _url,
                    bytes32 _latitude,
                    bytes32 _longitude,
                    string _timestamp,
                    bool _position,
                    string _description) {

                      OAR = OraclizeAddrResolverI(0x291d894f1c784011f3bf61f76b925ed40f007470);
        balance = msg.value;
        insuree = _insuree;
        url = _url;
        InsurancePool = msg.sender;
        latitude = _latitude;
        longitude = _longitude;
        timestamp = parseInt(_timestamp);
        position = _position;
        description = _description;

        cycles = 7;
        invariants = 2;

        if(!InsuranceLib.checkUrlHash(_hash, _url))
            throw;

        if(!InsuranceLib.checkResolverHash(_hash, prefix, _latitude, _longitude, _timestamp, suffix))
            throw;

        oraclize_query("URL", _url);
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;
        uint precipeMaxAmount = parseInt(result, 10);
        if((precipeMaxAmount > 0) != position) {
            invariants -= 1;
        } else {
            cycles -= 1;
        }
        if(!(invariants < 0)) {
            cancel();
        }
        if(cycles > 0) {
            oraclize_query("URL", url);
        } else {
            payout();
        }

    }

    function updateURL(bytes32 _hash, string _url, string _timestamp) onlyInsuree {
        if(!InsuranceLib.checkResolverHash(_hash, prefix, latitude, longitude, _timestamp, suffix))
            throw;
    }

    function payout() private {
            selfdestruct(insuree);
    }


    function cancel() private {
        selfdestruct(InsurancePool);
    }


}
