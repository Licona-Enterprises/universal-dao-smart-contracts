// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.4;

import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/presets/LSP7Mintable.sol";
import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/extensions/LSP7Burnable.sol";

// Lukso 0xB789fbA6532378151D2395f1171B1a7461BF6fBe
contract UNITToken is LSP7Mintable, LSP7Burnable {
    constructor(
        address tokenContractOwner_
    )
        LSP7Mintable(
            "Universal Token",
            "UNIT",
            msg.sender,
            0,
            false
        )
    {
        {
            mint(
              msg.sender, 
              500_000 * 10 ** decimals(), 
              true, // force parameter
              "0x"  // optional transaction data
            );

            mint(
              tokenContractOwner_, 
              500_000 * 10 ** decimals(), 
              true, // force parameter
              "0x"  // optional transaction data
            );
        }
    }
}