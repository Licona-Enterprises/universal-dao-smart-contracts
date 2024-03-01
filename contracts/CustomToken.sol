// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.4;

import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/presets/LSP7Mintable.sol";
import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/extensions/LSP7Burnable.sol";

contract CustomToken is LSP7Mintable, LSP7Burnable {
    // for more informations, check https://github.com/lukso-network/LIPs/blob/main/LSPs/LSP-7-DigitalAsset.md
    constructor(
        string memory tokenName_,
        string memory tokenSymbol_
    )
        LSP7Mintable(
            tokenName_,
            tokenSymbol_,
            msg.sender,
            0,
            false
        )
    {

    }

    function mintToken(address _to, uint256 _amount) external {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        mint(_to, _amount, true, "0x");
    }

    function burnToken(address _from, uint256 _amount) external {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        burn(_from, _amount, "0x");
    }

    function transferToken(address _from, address _to, uint256 _amount) external {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        transfer(_from, _to, _amount, true, "0x");
    }
    fallback() override external payable {}
}