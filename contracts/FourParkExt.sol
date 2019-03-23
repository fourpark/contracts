pragma solidity ^0.5.6;

import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token-enumerable.sol";
import "@0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";

contract FourParkExt is Ownable, NFTokenMetadata, NFTokenEnumerable {

  enum FrozenState { Frozen, NotFrozen }
  enum SecuredState { Secured, NotSecured }

  // Frozen state array variable
  mapping (uint256 => FrozenState) public FrozenMap;
  mapping (uint256 => SecuredState) public SecuredMap;



  /***********************************************

  Frozen

  ***********************************************/

  // Modifier to require non-frozen state of token
  modifier onlyNotFrozen(uint256 _tokenId) {
    require(FrozenMap[_tokenId] == FrozenState.NotFrozen);
    _;
  }
  
  // Modifier to require frozen state of token
  modifier onlyFrozen(uint256 _tokenId) {
    require(FrozenMap[_tokenId] == FrozenState.Frozen);
    _;
  }

  /**********************************************/

  // Function to freeze token
  function freezeToken(uint256 _tokenId)
    public
    returns (bool)
  {
    require(FrozenMap[_tokenId] == FrozenState.NotFrozen);
    FrozenMap[_tokenId] = FrozenState.Frozen;
    return true;
  }

  // Function to unFreezeToken
  function unFreezeToken(uint256 _tokenId)
    public
    returns (bool)
  {
    require(FrozenMap[_tokenId] == FrozenState.Frozen);
    FrozenMap[_tokenId] = FrozenState.NotFrozen;
    return true;
  }

  // Function to query state of token, no gas
  function frozenState(uint256 _tokenId) public view returns (FrozenState) {
    return FrozenMap[_tokenId];
  }



  /***********************************************

  Secured

  ***********************************************/

  // Modifier to require secured state of token
  modifier onlySecured(uint256 _tokenId) {
    require(SecuredMap[_tokenId] == SecuredState.Secured);
    _;
  }

  // Modifier to require not secured state of token
  modifier onlyNotSecured(uint256 _tokenId) {
    require(SecuredMap[_tokenId] == SecuredState.NotSecured);
    _;
  }

  /**********************************************/
  
  // Function to secure token
  function secureToken(uint256 _tokenId)
    public
    onlyNotSecured(_tokenId)
    returns (bool)
  {
    SecuredMap[_tokenId] = SecuredState.Secured;
    return true;
  }

  // Function to unsecure token
  function unsecureToken(uint256 _tokenId)
    public
    onlySecured(_tokenId)
    returns (bool)
  {
    SecuredMap[_tokenId] = SecuredState.NotSecured;
    return true;
  }

  // Function to query state of token, no gas
  function getSecuredState(uint256 _tokenId) public view returns (SecuredState) {
    return SecuredMap[_tokenId];
  }

}