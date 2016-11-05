pragma solidity ^0.4.0;

import "https://github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";

contract Temperature is usingOraclize {
    
    address owner;
    string public temp;
    

    function Temperature() {
        owner = msg.sender;
        OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
        update();
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;
        temp = result;
    }
    
    function update() payable {
        oraclize_query("URL", "json(https://api.darksky.net/forecast/e5fa70950b02e623da2a1c7159f8ee93/37.8267,-122.4233).currently.temperature");
    }
    
    function kill(){
        if (msg.sender == owner) suicide(msg.sender);
    }
    
}

