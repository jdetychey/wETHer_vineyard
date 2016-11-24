pragma solidity ^0.4.4;

contract InsurancePool {
    /* stuff and arrays */
    address[] public newContracts;
    uint256 public fee;
    address public admin;

    /* admin exclusivity */
  
    modifier onlyAdmin {
        if(msg.sender != admin) throw;
        _;
    }

    /* CONSTRUCTOR */
    // InsurancePool has to come with a supply so you have to send ether 
    //  at deployment ; fee is set a 0 by default

    function InsurancePool() {
        admin = msg.sender;
        fee = 0;
    }

    /* ADMIN METHODS */
    
    function setFee(uint _fee) onlyAdmin {
        fee = _fee;
    }
    
    function changeAdmin(address _admin) onlyAdmin {
        admin = _admin;
    }
    
    function load() payable {}
    
    /* POLICY METHOD */

   function createNewPolicy(string _url,
                            uint256 _coverage,
                            string _description) payable {
       uint256 _total = msg.value - fee + _coverage;
       address _insuree = msg.sender;
       address newContract = (new InsurancePolicy).value(_total)(_insuree,
       _url, _description, admin);
           newContracts.push(newContract);
   }


    /* BLOCKCHAIN CLEARING */

      function kill() onlyAdmin {
        selfdestruct(admin);
    }
}

contract InsurancePolicy {
    
    InsurancePolicy ispayable;
    // for the sake of the demo we introduce Resolver a trusted third party
    /* stuff and arrays */
    
    uint public balance;
    address public insuree;
    address public InsurancePool;
    address public resolver; //the address that will remotly activate the payout
    string public description;
    string public url;
    
    /* resolver (admin) exclusivity */

    modifier onlyResolver {
        if(msg.sender != resolver) throw;
        _;
    }
    
    /* constructor */

    function InsurancePolicy(address _insuree,
                    string _url,
                    string _description, address _resolver) payable {
        resolver = _resolver ; //the resolver is the admin of the InsurancePool
        insuree = _insuree;
        url = _url;
        InsurancePool = msg.sender;
        description = _description;
}

    /* resolver methods */

    function payout() onlyResolver() {
            selfdestruct(insuree);
    }

    function cancel() onlyResolver() {
        selfdestruct(InsurancePool);
    }
}
