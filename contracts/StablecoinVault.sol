// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
import "contracts/StablecoinVaultLib.sol";

// sepolia 0xA0570a4ee9ab8215192062C21c0c55d67e0e1152
contract StablecoinVault is Initializable, AccessControlUpgradeable, UUPSUpgradeable {
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    using StablecoinVaultLib for StablecoinVaultLib.VaultData;
    StablecoinVaultLib.VaultData private vaultData;

    function initialize(address defaultAdmin, address upgrader)
        initializer public
    {
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(UPGRADER_ROLE, upgrader);
    }

    function initVault(uint256 multisigThreshold) external onlyRole(DEFAULT_ADMIN_ROLE) {
        vaultData.init(multisigThreshold);
    }

    function setMultisig(address account, bool enabled) external onlyRole(DEFAULT_ADMIN_ROLE) {
        vaultData.setMultisig(account, enabled);
    }

    function setMultisigThreshold(uint256 multisigThreshold) external {
        vaultData.setMultisigThreshold(multisigThreshold);
    }

    function deposit(address token, uint256 amount) external {
        // Transfer tokens from sender to contract
        vaultData.deposit(token, amount);
    }

    function withdraw(address token, address recipient, uint256 amount) external {
        vaultData.withdraw(token, recipient, amount);
    }

    function getBalance(address account, address token) external view returns (uint256) {
        return vaultData.getBalance(account, token);
    }

    function getBalances(address account, address[] calldata tokens) external view returns (uint256[] memory) {
        return vaultData.getBalances(account, tokens);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(UPGRADER_ROLE)
        override
    {}
}
