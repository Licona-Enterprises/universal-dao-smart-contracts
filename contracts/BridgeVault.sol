// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// sepolia 0xb17B0E79d5f795a7c53bE86F4c4840cEbEf7BD11 
contract BridgeVault is Initializable, PausableUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
    mapping(address => mapping(address => uint256)) private balances;

    event TokensDeposited(address indexed token, address indexed depositor, uint256 amount);
    event TokensWithdrawn(address indexed token, address indexed recipient, uint256 amount);


    function initialize() initializer public {
        __Pausable_init();
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function deposit(address token, uint256 amount) external {
        require(IERC20(token).balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        // TODO approve this contract to spend, then transfer from 
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        balances[msg.sender][token] += amount;
        emit TokensDeposited(token, msg.sender, amount);
    }

    function withdraw(address token, uint256 amount) external {
        require(IERC20(token).balanceOf(address(this)) >= amount, "Insufficient balance");
        require(balances[msg.sender][token] >= amount, "Insufficient balance");
        
        IERC20(token).transfer(msg.sender, amount);
        balances[msg.sender][token] -= amount;

        emit TokensWithdrawn(token, msg.sender, amount);
    }

    function balanceOf(address token, address account) external view returns (uint256) {
        return balances[account][token];
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}
}
