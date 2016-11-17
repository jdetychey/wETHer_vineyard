pragma solidity ^0.4.0;
/*
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$ The LIB won't be used $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
library InsuranceLib {
    
    function calcCoverage(uint _principal, uint _fee, uint _probability) internal returns(uint) {
        if(_probability > 50) throw;
        uint _total = _principal - _fee;
        uint _div = (100 - (100 % _probability)) / _probability;
        
        return (_total - (_total % _div)) / _div;
    }
    
    function checkUrlHash(bytes32 _hash, string _url) internal returns(bool) {
        bytes32 urlHash = sha3(_url);
        for(uint i = 0; i < _hash.length; i++) {
            if(_hash[i] != urlHash[i])
                return false;
        }
        return true;
    }
    
    function checkProbHash(bytes32 _hash,
                        string _prefix,
                        bytes32 _latitude, 
                        bytes32 _longitude,
                        string _midfix,
                        string _num,
                        string _suffix) internal returns(bool) {
        string memory latitude = bytes32ToString(_latitude);
        string memory longitude = bytes32ToString(_longitude);
        bytes32 probHash = sha3(_prefix, latitude, ",", longitude,_midfix, _num, _suffix);
        
        for(uint i = 0; i < _hash.length; i++) {
            if(_hash[i] != probHash[i])
                return false;
        }
        return true;
    }
        
    function checkResolverHash(bytes32 _hash, 
                            string _prefix, 
                            bytes32 _latitude, 
                            bytes32 _longitude, 
                            string _timestamp, 
                            string _suffix) internal returns(bool) {
        string memory latitude = bytes32ToString(_latitude);
        string memory longitude = bytes32ToString(_longitude);
        bytes32 resolverHash = sha3(_prefix, latitude, ",", longitude, ",", _timestamp, _suffix);
        
        for(uint i=0; i< _hash.length; i++) {
            if(_hash[i] != resolverHash[i])
                return false;
        }
        return true;
    }
    
    function stringToBytes32(string input) internal returns (bytes32 output) {
        bytes memory tobytes = bytes(input);
        uint x = 0;
        for (uint y = 0; y < 32; y++) {
            if (y < tobytes.length) {
                x = x | uint(tobytes[y]);
            }
            if (y < 31) x = x * 256;
        }
        return bytes32(x);
   }
   
   function bytes32ToString (bytes32 data) internal returns (string) {
        bytes memory bytesString = new bytes(32);
        for (uint j=0; j<32; j++) {
            byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[j] = char;
            }
        }
        return string(bytesString);
    }
}
*/
