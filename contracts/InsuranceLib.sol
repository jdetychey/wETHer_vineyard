pragma solidity ^0.4.0;

library InsuranceLib {
    
    function calcProbability(int _value, int _fee, int _probability) internal returns(int) {
        return _value * (-1 - _fee + 100/_probability);
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
                        string _latitude, 
                        string _longitude,
                        string _suffix) internal returns(bool) {
        bytes32 probHash = sha3(_prefix, _latitude, ",", _longitude, _suffix);
        
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
                            uint _timestamp, 
                            string _suffix) internal returns(bool) {
        bytes32 resolverHash = sha3(_prefix, _latitude, ",", _longitude, ",", _timestamp, _suffix);
        
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
