/// @title Prediction markets for weather forecast
/// @author Physes


	/* Needs to be connected to API */

pragma solidity ^0.4.2;

contract Policy {
    
    uint public pool;
    
    bool public met;
    
    bytes32 latitude;
    bytes32 longitude;
    uint64 start;
    uint64 timeout;
    
    uint public pro;
    uint public con;
    
    uint public withdrawal;
    uint count;
    
    modifier onlyAfter {
        if(now < (timeout - start)) throw;
        _;
    }
    
    modifier onlyBefore {
        if(now > (timeout - start)) throw;
        _;
    }
    
    function Policy(bytes32 _latitude, bytes32 _longitude, uint64 _timeout) {
        latitude = _latitude;
        longitude = _longitude;
        timeout = _timeout;
    }
    
    mapping(address => bool) insurees;
    
    function bet(bool _willhappen, uint _amount) payable onlyBefore returns(bool) {
        if(msg.value != _amount)
            return false;
        pool += msg.value;
        insurees[msg.sender] = _willhappen;
        return true;
    }
    
    function check() {
        /* API check... */
        
    }
    
    function withdraw() onlyAfter returns(bool) {
        if(insurees[msg.sender] == met){
            if(met) {
                withdrawal = pool/pro;
            } else {
                withdrawal = pool/con;
            }
            msg.sender.send(withdrawal);
            return true;
        } else {
            return false;
        }
        
    }
    
    
}



