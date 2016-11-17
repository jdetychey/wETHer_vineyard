pragma solidity ^0.4.4;

contract InsurancePool { 
    mapping(address => address) insurees;


    uint public fee;
    uint public minimum;
    address public admin;

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
    
    /* POLICY METHOD */

    function createNewPolicy(string _url,
                             uint _coverage,
                             string _description) minimumLiquidity returns(address) {

        insurees[msg.sender] = new InsurancePolicy(msg.sender, _url,_description, admin);
        uint _total = (msg.value - fee) + _coverage;

        if(!insurees[msg.sender].send(_total))
            throw;


    }
    
    /* BLOCKCHAIN CLEARING */
      function kill()onlyAdmin {
        selfdestruct(admin);
    }
}

contract InsurancePolicy {
    // for the sake of the demo we introduce Resolver a trusted third party
    uint public balance;
    address public insuree;
    address public InsurancePool;
    address public resolver; //the address that will remotly activate the payout
    string public description;
    string public url;


    modifier onlyResolver {
        if(msg.sender != resolver) throw;
        _;
    }

    function InsurancePolicy(address _insuree,
                    string _url,
                    string _description, address _resolver) {

        balance = msg.value;
        resolver = _resolver ; //the resolver is the admin of the InsurancePool
        insuree = _insuree;
        url = _url;
        InsurancePool = msg.sender;

        description = _description;
}
    function payout() private onlyResolver() {
            selfdestruct(insuree);
    }


    function cancel() private onlyResolver() {
        selfdestruct(InsurancePool);
    }


}
