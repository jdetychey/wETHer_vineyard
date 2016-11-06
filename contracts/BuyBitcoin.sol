pragma solidity ^0.4.0;

import "https://github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";

contract BuyBitcoin is usingOraclize {
    
    address owner;
    string public temp;
    

    function BuyBitcoin() {
        owner = msg.sender;
        
        OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
        update();
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;
        result;
    }
    
    function update() payable {
        oraclize_query("URL", "json(https://www.shapeshift.io/shift).orderId", '{"withdrawal":"3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy", "pair":"eth_btc" , "amount" : 1000}');
    }
    
    function kill(){
        if (msg.sender == owner) suicide(msg.sender);
    }
    
}
