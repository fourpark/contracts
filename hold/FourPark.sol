pragma solidity ^0.5.6;

import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token.sol";
import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token-enumerable.sol";
import "@0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";

contract FourPark is NFToken, NFTokenMetadata, NFTokenEnumerable, Ownable {

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
    onlyNotFrozen(_tokenId)
    returns (bool)
  {
    FrozenMap[_tokenId] = FrozenState.Frozen;
    return true;
  }

  // Function to unFreezeToken
  function unFreezeToken(uint256 _tokenId)
    public
    onlyFrozen(_tokenId)
    returns (bool)
  {
    FrozenMap[_tokenId] = FrozenState.NotFrozen;
    return true;
  }

  // Function to query state of token, no gas
  function getFrozenState(uint256 _tokenId) public view returns (FrozenState) {
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



  /***********************************************

  Overlay Functions

  ***********************************************/

  /**
   * @dev Mints a new NFT.
   * @param _to The address that will own the minted NFT.
   * @param _tokenId of the NFT to be minted by the msg.sender.
   * @param _uri String representing RFC 3986 URI.
   */
  function mint(
    address _to,
    uint256 _tokenId,
    string calldata _uri
  )
    external
    onlyOwner
  {
    freezeToken(_tokenId);
    unsecureToken(_tokenId);
    super._mint(_to, _tokenId);
    super._setTokenUri(_tokenId, _uri);
  }

  /**
   * @dev Removes a NFT from owner.
   * @param _tokenId Which NFT we want to remove.
   */
  function burn(
    uint256 _tokenId
  )
    external
    onlyOwner
  {
    super._burn(_tokenId);
  }

  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes calldata _data
  )
    external
    onlyNotFrozen(_tokenId)
    onlySecured(_tokenId)
  {
    NFToken.safeTransferFrom(_from, _to, _tokenId, _data);
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external
    onlyNotFrozen(_tokenId)
    onlySecured(_tokenId)
  {
    NFToken.transferFrom(_from, _to, _tokenId);
  }

}