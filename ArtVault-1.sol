pragma solidity ^0.5.6;

import "https://github.com/fourpark/contracts/FourPark.sol";

/**
 * @dev This is an example contract implementation of NFToken with metadata extension.
 */
contract FPMV1 is
  FourPark
{

  /**
   * @dev Contract constructor. Sets metadata extension `name` and `symbol`. 
   */
  constructor()
    public
  {
    nftName = "Vault 1";
    nftSymbol = "FPMV1";
  }

}