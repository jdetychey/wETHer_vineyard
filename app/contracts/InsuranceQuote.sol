pragma solidity ^0.4.0;

import "./lib/usingOraclize.sol";
import "./lib/InsuranceLib.sol";

contract InsuranceQuote is usingOraclize {

    using InsuranceLib for *;

    address public insuree;
    bytes32 public probability;

    bytes32 public latitude;
    bytes32 public longitude;

    modifier onlyInsuree {
        if(msg.sender != insuree) throw;
        _;
    }


    /* PROBABILITY QUERY STRINGS */

    string constant prefix = "json(https://api.darksky.net/forecast/e5fa70950b02e623da2a1c7159f8ee93/";
    string constant midfix = ").daily.data[";
    string constant suffix = "].precipProbability";


    function InsuranceQuote() {
        OAR = OraclizeAddrResolverI(0x291d894f1c784011f3bf61f76b925ed40f007470);
        //insuree = _insuree;
        //getProbability(_hash, _url, _latitude, _longitude, "1");
    }

    function getProbability(bytes32 _hash, string _url, bytes32 _latitude, bytes32 _longitude, string _num) external {
         /*if(!InsuranceLib.checkUrlHash(_hash, _url))
            throw;
        if(!InsuranceLib.checkProbHash(_hash, prefix, _latitude, _longitude, midfix, _num, suffix))
            throw;*/
        latitude = _latitude;
        longitude = _longitude;

        oraclize_query("URL", _url);
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;
        probability = InsuranceLib.stringToBytes32(result);
    }

    function cancel() onlyInsuree {
        selfdestruct(msg.sender);
    }
}
