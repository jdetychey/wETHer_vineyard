pragma solidity ^0.4.0;

import "https://github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";
import "InsuranceLib.sol";


contract InsurancePolicy {
    
    uint public balance;
    
    address insuree;
    address public InsurancePool;
    
    string public latitude;
    string public longitude;
    
    uint64 public start;
    uint64 public timeout;
    uint64 public invariants;
    
    string public description;
    
    /* RESOLVER QUERY STRINGS */
    string constant prefix = "json(https://api.darksky.net/forecast/e5fa70950b02e623da2a1c7159f8ee93/";
    string constant suffix = ").daily.data[0].precipIntensityMax,precipType";
    
    
    bool public position;
    
    
    modifier onlyInsuree {
        if(msg.sender != insuree) throw;
        _;
    }
    
    function InsurancePolicy(address _insuree,
                    string _latitude, 
                    string _longitude, 
                    uint64 _timeout,
                    bool _position,
                    uint _invariants,
                    string _description) {
        balance = msg.value;
        insuree = _insuree;
        InsurancePool = msg.sender;
        latitude = _latitude;
        longitude = _longitude;
    }
    
}