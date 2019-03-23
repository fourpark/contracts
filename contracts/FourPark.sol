pragma solidity ^0.5.6;

import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token-enumerable.sol";
import "@0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";

import "./FourParkExt.sol";

contract FourPark is Ownable, NFTokenMetadata, NFTokenEnumerable, FourParkExt  {

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
    onlyUnfrozen(_tokenId)
    onlySecured(_tokenId)
  {
    super._safeTransferFrom(_from, _to, _tokenId, _data);
  }

    function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external
    onlyUnfrozen(_tokenId)
    onlySecured(_tokenId)
  {
    super._transferFrom(_from, _to, _tokenId);
  }

  

}