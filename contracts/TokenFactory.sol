// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "contracts/CustomToken.sol";
import "contracts/TokenFactoryLib.sol";

// lukso 0x1B2a5B56EE931eA249829E8665CE8940a4421A8b
contract TokenFactory is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    using TokenFactoryLib for TokenFactoryLib.TokenStorage;
    TokenFactoryLib.TokenStorage private tokenStorage;

    function initialize() initializer public {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function mintOrDeployToken(string memory symbol, string memory name, uint256 amount, address recipient, address _evmAddress) external onlyOwner {
        tokenStorage.mintOrDeployToken(symbol, name, amount, recipient, _evmAddress);
    }

    function burnTokenGoHome(string memory symbol,uint256 amount, address recipient, address _evmAddress) external {
        tokenStorage.burnLsp7Token(symbol, amount, recipient, _evmAddress);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}
}

