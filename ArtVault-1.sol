pragma solidity 0.5.2;

import "https://github.com/fourpark/721-fourpark-extension/FourPark.sol";

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