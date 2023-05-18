// SPDX-License-Identifier: CC-BY-1.0

pragma solidity >=0.7.0 <0.9.0;

contract insurancePolicies {



    struct Tpoliza {
        string id;
        address payable ensured;
        string idbenefitiary;
        TEstates state;
        uint rates;
    }
    struct Trates {
      mapping(string => uint) rate;
    }

  // States of the policy
  //    Active policy means the risk is protected
  //    Retired means the customer is retired and policy is no longer valid
  //    Loss means the risk was materialized and a claim was made
  enum TEstates { Active, Retired, Loss }
  // TEProduct are the tipes of policies available.
  enum TEProduct { life, health, hospital, elder }

  // Container for all policies
  Tpoliza[] public polizas;
  Trates rates;

constructor() {
  rates.rate["life"] = 100;
  rates.rate["health"] = 200;
  rates.rate["hospital"] = 300;
  rates.rate["elder"] = 400;
}

function addPolicy(string memory _id, address payable _ensured, string memory _idbenefitiary, TEstates _state, TEProduct _product, uint _rate) public {
        require(_rate > 0, "Rate must be greater than zero.");
        // verify restrictions according to TEProduct
        if (_product == TEProduct.life) {
            require(_rate <= rates.rate["life"], "Rate exceeds maximum limit for ProductA.");
        } else if (_product == TEProduct.health) {
            require(_rate <= rates.rate["health"], "Rate exceeds maximum limit for ProductB.");
        } else if (_product == TEProduct.hospital) {
            require(_rate <= rates.rate["hospital"], "Rate exceeds maximum limit for ProductC.");
        } else if (_product == TEProduct.elder) {
            require(_rate <= rates.rate["elder"], "Rate exceeds maximum limit for ProductC.");
        }
        Tpoliza memory newPolicy = Tpoliza(_id, _ensured, _idbenefitiary, _state, _rate);
        polizas.push(newPolicy);
  }

  //Helper function to compare strings converting them to bytes before converting them to hashes
  function compareStrings(string memory a, string memory b) public pure returns (bool) {
      return (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)));
  }
  //Function to change the state of a policy to Retired
  function RetirePolicy(string memory _id) public {
    for (uint i=0; i < polizas.length; i++){
      if (compareStrings(polizas[i].id,_id) )
        polizas[i].state = TEstates.Retired;
    }
  }

  function claimPolicy(string memory _id) public {
    for( uint i=0; i<polizas.length; i++){
      if( compareStrings(polizas[i].id,_id) ) {
        polizas[i].state = TEstates.Loss;
      }
    }
  }

  function totalAmountActivePolicy() public view returns (uint) {
    uint amount = 0;
    for( uint i=0; i<polizas.length; i++ ) {
      if( polizas[i].state == TEstates.Active ){
        amount += polizas[i].rates;
      }
    }
    return amount;
  }

  function totalAmountRetiredPolicy() public view returns (uint) {
    uint amount = 0;
    for( uint i=0; i<polizas.length; i++ ) {
      if( polizas[i].state == TEstates.Retired ){
        amount += polizas[i].rates;
      }
    }
    return amount;
  }

  function totalAmountClaimed() public view returns (uint) {
    uint amount = 0;
    for( uint i=0; i<polizas.length; i++ ) {
      if( polizas[i].state == TEstates.Loss ){
        amount += polizas[i].rates;
      }
    }
    return amount;
  }


}
