// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 

library StablecoinVaultLib {

    struct VaultData {
        mapping(address => mapping(address => uint256)) balances;
        mapping(address => bool) multisig;
        uint256 multisigThreshold;
    }

    event MultisigChanged(address indexed account, bool enabled);
    event MultisigThresholdChanged(uint256 newThreshold);
    event Withdraw(address indexed token, address indexed recipient, uint256 amount);

    modifier onlyMultisig(VaultData storage self) {
        require(self.multisig[msg.sender], "Only multisig signers can call this function");
        _;
    }
        
    function init(VaultData storage self, uint256 _multisigThreshold) external {
        // self.owner = msg.sender;
        self.multisigThreshold = _multisigThreshold;
        self.multisig[msg.sender] = true;
    }

    function setMultisig(VaultData storage self, address account, bool enabled) external {
        self.multisig[account] = enabled;
        emit MultisigChanged(account, enabled);
    }

    function setMultisigThreshold(VaultData storage self, uint256 _multisigThreshold) external {
        self.multisigThreshold = _multisigThreshold;
        emit MultisigThresholdChanged(_multisigThreshold);
    }

    function deposit(VaultData storage self, address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(token != address(0), "Token address cannot be zero");

        // Transfer tokens from sender to contract
        IERC20(token).approve(msg.sender, amount);
        IERC20(token).approve(address(_vaultContractAddress), amount);
        
        bool success = IERC20(token).transferFrom(msg.sender, address(_vaultContractAddress), amount);
        require(success, "Token transfer failed");

        // Update balance
        self.balances[msg.sender][token] += amount;
    }

    function withdraw(VaultData storage self, address token, address recipient, uint256 amount) external onlyMultisig(self) {
        require(amount > 0, "Amount must be greater than zero");
        require(token != address(0), "Token address cannot be zero");

        // Verify multisig threshold
        uint256 signaturesCount;
        for (uint256 i = 0; i < self.multisigThreshold; i++) {
            if (self.multisig[msg.sender]) {
                signaturesCount++;
            }
        }
        require(signaturesCount >= self.multisigThreshold, "Insufficient multisig signatures");

        // Transfer tokens to recipient
        bool success = IERC20(token).transfer(recipient, amount);
        require(success, "Token transfer failed");

        // Update balance
        self.balances[recipient][token] -= amount;

        emit Withdraw(token, recipient, amount);
    }

    function getBalance(VaultData storage self, address account, address token) external view returns (uint256) {
        return self.balances[account][token];
    }

    function getBalances(VaultData storage self, address account, address[] calldata tokens) external view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            balances[i] = self.balances[account][tokens[i]];
        }
        return balances;
    }
}