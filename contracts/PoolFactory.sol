pragma solidity ^0.8.0;

import "./Pool.sol";

contract PoolFactory {
    mapping(address => mapping(address => address)) public pools;
    address[] public allPools;

    address public immutable admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    constructor() {
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

    function createPool(address tokenA, address tokenB)
        external
        returns (address pool)
    {
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);

        require(pools[token0][token1] == address(0), "POOL_EXISTS");

        pool = address(new Pool(tokenA, tokenB));

        pools[token0][token1] = pool;
        pools[token1][token0] = pool;
        allPools.push(pool);
    }
}
