pragma solidity ^0.4.0;
//import "https://github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";
//import "https://github.com/jdetychey/wETHer_vineyard/blob/master/contracts/InsuranceLib.sol";


contract InsurancePool { /* won't require Oraclize in the pool

is usingOraclize {
    using InsuranceLib for *;*/

    /* FIELDS */

    mapping(address => address) quotes;
    mapping(address => address) insurees;
//    mapping(address => uint) balanceOf;
/* balanceOf is only used in the drops DAO scheeme */
    uint fee;
    uint minimum;

//    uint public pool;
    // uint public drops;

    address admin;
    address auth;

    /*auth is the public key (the address) that will be used to authentificate
    data provided by the client with ecrecover*/

    /* MODIFIERS */

    modifier onlyAdmin {
        if(msg.sender != admin) throw;
        _;
    }

    modifier minimumLiquidity {
        if(this.balance < minimum) throw;
        _;
    }

    /* CONSTRUCTOR */
    // InsurancePool comes with supply fee and minimum
    function InsurancePool(uint _supply, uint _fee, uint _minimum) {

        //OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);

        admin = msg.sender;
        //drops = _supply;
        //balanceOf[admin] = drops;
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
    /* will now be done on server side and signed by a priv key */
    /*function setQuote(bytes32 _hash, string _url, bytes32 _latitude, bytes32 _longitude) returns(bool){
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
        bytes32 _probability = InsuranceQuote(q).probability();
        string memory probability = InsuranceLib.bytes32ToString(_probability);
        return usingOraclize.parseInt(probability);
    }

    */
    /* INSURANCE POLICY METHODS */
/*
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$ HOW IT SHOULD BE DONE $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

createNewPolicy should use ecrecover to throw, testing if the address returned
by ecrecover is == auth; the thing is ecrecover takes 4 arg and
ecrecover returns the address that is supposed to have signed 
the hash for the signature has to be done serverside this way

hash = sha3(_url, _timeout, _position, _coverage);

the signing is then:

signed = eth.sign(auth, hash).slice(2); //where auth is the address whose private key
will be used to sign
signed contains the different arguments for ecrecover
 r = signed.slice(0, 64);
 s = signed.slice(64, 128);
 v = 27 // or 28

the function of the contract will than test
ecrecover(hash, v, r, s) == auth

therefore the client only have to feed those variable to the contract:
_url, _timeout, _position, _coverage, _r, _s ;


    function createNewPolicy(string _url,
                            string _timeout,
                            bool _position,
                            uint _coverage,
                            bytes32 _r,
                            bytes32 _s,
                            string _description) minimumLiquidity returns(address) {
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
*/
/* for the purpose of the demo!!*/
    function createNewPolicy(string _url,
                             string _timeout,
                             bool _position,
                             uint _coverage,
                             string _description) minimumLiquidity returns(address) {
//        address q = quotes[msg.sender];
//        bytes32 _latitude = bytes32(InsuranceQuote(q).latitude());
//        bytes32 _longitude = bytes32(InsuranceQuote(q).longitude());
//        uint _probability = getQuote();
//        uint _coverage = InsuranceLib.calcCoverage(msg.value, fee, _probability);

//        delete quotes[msg.sender];
//        if(!q.delegatecall(bytes4(sha3("cancel()"))))
//            throw;

        insurees[msg.sender] = new InsurancePolicy(msg.sender, _url, _timeout,
                                                 _description);
//        balanceOf[admin] -= _coverage;
        pool -= _coverage;
        uint _total = (msg.value - fee) + _coverage;

        if(!insurees[msg.sender].send(_total))
            throw;


    }


    /* LIQUIDITY METHODS */
    //to be added later
    /*
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

*/
    /* PROBABILITY QUERY STRINGS */
    //done server wise
/*    string constant prefix = "json(https://api.darksky.net/forecast/e5fa70950b02e623da2a1c7159f8ee93/";
    string constant midfix = ").daily.data[";
    string constant suffix = "].precipProbability";


    function InsuranceQuote(address _insuree, bytes32 _hash, string _url, bytes32 _latitude, bytes32 _longitude) {
        OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
        insuree = _insuree;

        getProbability(_hash, _url, _latitude, _longitude, "1");
    }

    function getProbability(bytes32 _hash, string _url, bytes32 _latitude, bytes32 _longitude, string _num) onlyInsuree {
         if(!InsuranceLib.checkUrlHash(_hash, _url))
            throw;
        if(!InsuranceLib.checkProbHash(_hash, prefix, _latitude, _longitude, midfix, _num, suffix))
            throw;
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
*/
contract InsurancePolicy {
    // is usingOraclize {
    // resolution will be done manually and integrated later
    // for the sake of the demo we introduce Resolver a trusted third party
    uint public balance;

    address insuree;
    address public InsurancePool;
    address public Resolver; //the address that will remotly activate the payout

    bytes32 public latitude;
    bytes32 public longitude;

    uint public start;
    uint public timestamp;

    //uint cycles;
    //uint invariants;

    string public description;

    string public url;

    /* RESOLVER QUERY STRINGS */
    /*string constant prefix = "json(https://api.darksky.net/forecast/e5fa70950b02e623da2a1c7159f8ee93/";
    string constant suffix = ").daily.data[0].precipIntensityMax,precipType";
    */

    bool public position;


    modifier onlyResolver {
        if(msg.sender != Resolver) throw;
        _;
    }

    function InsurancePolicy(address _insuree,
//                    bytes32 _hash,
                    string _url,
//                    bytes32 _latitude,
//                    bytes32 _longitude,
                    string _timestamp,
                    bool _position,
                    string _description) {

        //OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
        balance = msg.value;
        Resolver = 0x21dbbd0A06b53B1270A02b0870EcDc83910D47c0 //hardcoded 
        insuree = _insuree;
        url = _url;
        InsurancePool = msg.sender;
        latitude = _latitude;
        longitude = _longitude;
        timestamp = parseInt(_timestamp);
        position = _position;
        description = _description;

        //cycles = 7;
        //invariants = 2;

        /*if(!InsuranceLib.checkUrlHash(_hash, _url))
            throw;

        if(!InsuranceLib.checkResolverHash(_hash, prefix, _latitude, _longitude, _timestamp, suffix))
            throw;

        oraclize_query("URL", _url);*/
    }

    /*function __callback(bytes32 myid, string result) {
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
    */
    /*function updateURL(bytes32 _hash, string _url, string _timestamp) onlyInsuree {
        if(!InsuranceLib.checkResolverHash(_hash, prefix, latitude, longitude, _timestamp, suffix))
            throw;
    }
    */
    function payout() private onlyResolver() {
            selfdestruct(insuree);
    }


    function cancel() private onlyResolver() {
        selfdestruct(InsurancePool);
    }


}
