// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol"; //for test

contract Pool {
    address owner;
    address tokenA;
    address tokenB;
    uint256 fees;

    constructor(address _tokenA, address _tokenB) {
        owner = payable(msg.sender);
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function getOwnerAndBalance() public view returns (address,uint) {
        return (owner,owner.balance);
    }
    function getTokenA()public view returns(address) {
    return tokenA;
    }
    function getTokenB()public view returns(address) {
    return tokenB;
    }
    function getFees()public view returns(uint) {
    return fees;
    }
    function balanceContract()public view returns(uint) {
    return address(this).balance;
    }

function getPriceToken(address outputToken, uint256 amount)public view returns(uint256){
         address inputToken = (tokenA == outputToken ? tokenB : tokenA);

        uint256 inputBalance = IERC20(inputToken).balanceOf(address(this));
        uint256 outputBalance = IERC20(outputToken).balanceOf(address(this));
        uint256 inputAmount = amount * (outputBalance / inputBalance);
        return inputAmount;
    }

    function swap(address outputToken, uint256 amount) public   {
        address inputToken = (tokenA == outputToken ? tokenB : tokenA);

        uint256 inputBalance = IERC20(inputToken).balanceOf(address(this));
        uint256 outputBalance = IERC20(outputToken).balanceOf(address(this));

         uint256 ratio = (outputBalance / inputBalance);

         fees = ratio * (amount-(uint (3) / 1000));
           //  2B *(1-0.003) = 1.994

        uint256 inputAmount = amount * (outputBalance / inputBalance);


        IERC20(inputToken).transferFrom(msg.sender, address(this), inputAmount);        
        IERC20(outputToken).transfer(msg.sender, amount);


        
    }
}
