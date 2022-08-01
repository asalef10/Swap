// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol"; //for test

contract Pool {
    address owner;

    address tokenA;
    address tokenB;

    constructor(address _tokenA, address _tokenB) {
        owner = msg.sender;
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function swap(address outputToken, uint256 amount) public {
        address inputToken = (tokenA == outputToken ? tokenB : tokenA);

        uint256 inputBalance = IERC20(inputToken).balanceOf(address(this));
        uint256 outputBalance = IERC20(outputToken).balanceOf(address(this));

        uint256 inputAmount = amount * (outputBalance / inputBalance);

        IERC20(inputToken).transferFrom(msg.sender, address(this), inputAmount);
        IERC20(outputToken).transfer(msg.sender, amount);
    }
}
