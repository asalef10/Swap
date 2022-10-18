interface ITokenFactory {
    function getTokenAddress(string memory tokenName) external view returns(address addressContract)  ;
    function createToken(string memory a, string memory b) external ;
    function getOwner() external view returns(address addressOwner);   
}
