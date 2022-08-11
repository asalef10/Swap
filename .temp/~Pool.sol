// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "c:/Users/Asalef alena/Desktop/swap/node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "c:/Users/Asalef alena/Desktop/swap/node_modules/@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol"; //for test

contract Pool {
    address owner;
    address tokenA;
    address tokenB;
    uint256 fees;

    constructor(address _tokenA, address _tokenB) {
        owner = msg.sender;
        tokenA = _tokenA;
        tokenB = _tokenB;
        fees = 1003;
    }

    function getOwnerAndBalance() public view returns (address, uint256) {
        return (owner, owner.balance);
    }

    function getTokenA() public view returns (address) {
        return tokenA;
    }

    function getTokenB() public view returns (address) {
        return tokenB;
    }

    function getFees() public view returns (uint256) {
        return fees;
    }

    function balanceContract() public view returns (uint256) {
        return address(this).balance;
    }

    function getInputPriceWithoutFee(address outputToken, uint256 amount)
        public
        view
        returns (address inputToken, uint256 inputAmount)
    {
        inputToken = (tokenA == outputToken ? tokenB : tokenA);

        uint256 inputBalance = IERC20(inputToken).balanceOf(address(this));
        uint256 outputBalance = IERC20(outputToken).balanceOf(address(this));
        inputAmount = (amount * inputBalance) / outputBalance;
    }

    function getInputPriceWithFee(address outputToken, uint256 amount)
        public
        view
        returns (address inputToken, uint256 inputAmount)
    {
        (inputToken, inputAmount) = getInputPriceWithoutFee(
            outputToken,
            amount
        );

        //add 0.003%
        inputAmount = (inputAmount * fees) / 1000;
    }

    function swap(address outputToken, uint256 amount) public {
        (address inputToken, uint256 inputAmount) = getInputPriceWithFee(
            outputToken,
            amount
        );

        IERC20(inputToken).transferFrom(msg.sender, address(this), inputAmount);
        
        IERC20(outputToken).transfer(msg.sender, amount);
    }
}
