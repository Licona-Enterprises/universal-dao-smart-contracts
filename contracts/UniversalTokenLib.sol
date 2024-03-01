// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.4;

import "contracts/UniversalToken.sol";

library UniversalTokenLib {
    struct TokenStorage {
        mapping(address => address payable) tokens;
    }

    event TokenDeployed(address indexed tokenAddress, string symbol, string name);
    event TokenBridged(address indexed tokenAddress, string symbol, string name);
    event TokenBurned(address indexed tokenAddress, string symbol);

    function deployToken(TokenStorage storage self, string memory symbol, string memory name, address _evmAddress) internal returns (address payable) {
        require(self.tokens[_evmAddress] == address(0), "Token already deployed");
        

        UniversalToken token = new UniversalToken(symbol, name);
        self.tokens[_evmAddress] = payable(address(token));

        emit TokenDeployed(address(token), symbol, name);
        return payable(address(token));
    }

    function mintOrDeployToken(TokenStorage storage self, string memory symbol, string memory name, uint256 amount, address _recipient, address _evmAddress) external {
        address payable tokenAddress = self.tokens[_evmAddress];
        if (tokenAddress == address(0)) {
            tokenAddress = deployToken(self, symbol, name, _evmAddress);
        }
        UniversalToken(tokenAddress).mintToken(_recipient, amount);
        emit TokenBridged(tokenAddress, symbol, name);
    }

    function burnLsp7Token(TokenStorage storage self, string memory symbol, uint256 amount, address _tokenHolder, address _evmAddress) external {
        address payable tokenAddress = self.tokens[_evmAddress];
        UniversalToken(tokenAddress).burnToken(_tokenHolder, amount);
        emit TokenBurned(tokenAddress, symbol);
    }
}