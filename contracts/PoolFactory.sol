// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./Pool.sol";
import "./interfaces/ITokenFactory.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract PoolFactory {
    
    mapping(address => mapping(address => address)) public pools;
    address[] public allPools;
    address internal addressFactoryERC20;
    address public immutable admin;
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    constructor() {
        addressFactoryERC20 = 0x5C8B3D04eA3734800929Fa710DFa5D09c9B0710F;
        admin = msg.sender;
    }

    function allPoolsLength() external view returns (uint256) {
        return allPools.length;
    }

    function getPool(address tokenA, address tokenB)
        external
        view
        returns (address)
    {
        return pools[tokenA][tokenB];
    }

function createTokenERC20() public  returns(address token) {
   ITokenFactory(addressFactoryERC20).createToken("a","b");

}

    function createPool(address tokenA, address tokenB)
        external
        returns (address pool)
    {
    //    address tokenA =  createERC20Token("tokenA","A");
    //    address tokenB =  createERC20Token("tokenB","B");

        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        require(pools[token0][token1] == address(0), "POOL_EXISTS");

       
        pool = address(new Pool(tokenA, tokenB));

        pools[token0][token1] = pool;
        pools[token1][token0] = pool;
        allPools.push(pool);
    }
}
