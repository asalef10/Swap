// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SwapToken{
address owner;
constructor(){
    owner = msg.sender;
}
function getOwenr()public view returns(address) {
    return owner;
}

function swap(address tokenA,address tokenB,uint amountX)public {
exchangeA = amountX* tokenB/tokenA
}

}