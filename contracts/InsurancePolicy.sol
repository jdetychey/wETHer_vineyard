pragma solidity ^0.4.0;

import "https://github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";
import "InsuranceLib.sol";


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
                        
        OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
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