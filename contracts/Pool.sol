// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol"; //for test


contract Pool is ERC20 {


    mapping(address=>uint256) internal intUserLiquidity;

    address owner;
    address tokenA;
    address tokenB;
    uint256 fees;

    constructor(address _tokenA, address _tokenB)ERC20("pool", "pl"){
        owner = msg.sender;
        tokenA = _tokenA;
        tokenB = _tokenB;
        _mint(address(this), 10 * (10 ** uint256(decimals())));
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
        return  IERC20(address(this)).balanceOf(address(this));
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

  
    function getBalanceToken(address outputToken,address userAddress)public view returns(uint256 amount ) {
      return IERC20(outputToken).balanceOf(userAddress);
    }

    function transferToken(address outputToken,address userTransfer,uint256 amount )public {
        IERC20(outputToken).transfer(userTransfer, amount);
    }
    
      function swap(address outputToken,uint256 restriction, uint256 amount) public {
        (address inputToken, uint256 inputAmount) = getInputPriceWithFee(
            outputToken,
            amount
        );

        require(inputAmount <= restriction,"It exceeds the amount limit for the operation");

        IERC20(inputToken).transferFrom(msg.sender, address(this), inputAmount);
        
        IERC20(outputToken).transfer(msg.sender, amount);
    }
    
//     function totalLiquidity()public view returns (uint256 totalLiquidty){
//          uint256 Token_A = IERC20(tokenA).balanceOf(address(this));
//          uint256 Token_B = IERC20(tokenB).balanceOf(address(this));
//          uint256 resultToken_A_B = Token_A + Token_B;
//          return resultToken_A_B;
// 
}
    function totalLiquidity()public view returns (uint256 totalLiquidty_A,uint256 totalLiquidty_B ){
         uint256 Token_A = IERC20(tokenA).balanceOf(address(this));
         uint256 Token_B = IERC20(tokenB).balanceOf(address(this));
         uint256 resultToken_A_B = Token_A + Token_B;
         return (Token_A,Token_B);
}
     function calculationLpToken(uint256 amountTokenA,uint256 amountTokenB)public view returns(uint256 lpFees)  {
        
         (uint256 resultToken_A, uint256 resultToken_B) = totalLiquidity();
         uint256 doubleLiq_A = (amountTokenA * 1000)/resultToken_A;
         uint256 doubleLiq_B = (amountTokenB * 1000)/resultToken_B;
         uint256 resultAB_Token = doubleLiq_A + doubleLiq_B;
         uint256 result = resultAB_Token * 100;
         return result/1000;

    }

    function addLiquidity(uint256 amountTokenA,uint256 amountTokenB)public {
        
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountTokenA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountTokenB);
        uint256 resultLP = calculationLpToken(amountTokenA,amountTokenB);
        intUserLiquidity[msg.sender] += resultLP;
        IERC20(address(this)).transfer(msg.sender,resultLP);
    } 
}
