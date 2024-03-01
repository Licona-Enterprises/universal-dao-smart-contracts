// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.23;

// lukso 0xF752aC5C3Dfcc55F68D7DafA8300EFdCf4E3cbc7
contract UniversalTokenVault {
    string public name     = "Universal Token";
    string public symbol   = "UNIT";
    uint8  public decimals = 18;

    event  Deposit(address indexed dst, uint256 wad);
    event  Withdrawal(address indexed src, uint256 wad);

    mapping (address => uint256)                       public  balanceOf;

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() public {
        // 0xAa6f663a14b8dA1EB9CF021379f4Ba6BF536268A is dev address for this contract, replace with mulit-sig address on mainnet
        require(msg.sender == payable(address(0xAa6f663a14b8dA1EB9CF021379f4Ba6BF536268A)));
        uint256 balance = address(this).balance;
        payable(address(0xAa6f663a14b8dA1EB9CF021379f4Ba6BF536268A)).transfer(balance);
        emit Withdrawal(msg.sender, balance);
    }

    receive() external payable {
        deposit();
    }
}

