// SPDX-License-Identifier: CC-BY-1.0

pragma solidity >=0.7.0 <0.9.0;

contract insurancePolicies {
  enum TEstates { Active, Retired, Loss }
  enum TEProduct { life, health, hospital, elder }
  mapping tarifas (string => uint);
  struct poliza {
    string id;
  }
}
