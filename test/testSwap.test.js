const Pool = artifacts.require("Pool");
const PoolFactory = artifacts.require("PoolFactory");

const ERC20 = artifacts.require("ERC20PresetFixedSupply");

// contract address work -- 0xCE0CF163224055e7229308A5cB9C6fdaDb29eB99 --

contract("Pool", (accounts) => {

  

  let tokenA, tokenB, tokenC;

  const issueAmount = web3.utils.toWei("100000000000000", "ether");

  let PoolInstance, PoolFactoryInstance, contractAddress;

  before(async () => {
    tokenA = await ERC20.new("tokenA", "A", issueAmount, accounts[0]);

    tokenB = await ERC20.new("tokenB", "B", issueAmount, accounts[0]);

    tokenC = await ERC20.new("tokenC", "C", issueAmount, accounts[0]);

    PoolFactoryInstance = await PoolFactory.deployed();

 

    await PoolFactoryInstance.createPool(tokenA.address, tokenB.address);

    let abAddress = await PoolFactoryInstance.getPool(
      tokenA.address,
      tokenB.address
    );

    PoolInstance = await Pool.at(abAddress);
    contractAddress = abAddress;
    await tokenA.approve(PoolInstance.address, issueAmount);
    await tokenB.approve(PoolInstance.address, issueAmount);
    await tokenC.approve(PoolInstance.address, issueAmount);

   
     await PoolFactoryInstance.createPool(tokenA.address, tokenC.address);

  

    await PoolFactoryInstance.createPool(tokenB.address, tokenC.address);

    await tokenA.transfer(abAddress, web3.utils.toWei("500", "ether"));
    await tokenB.transfer(abAddress, web3.utils.toWei("1000", "ether"));
  });

  it("Should swap token B to token A", async () => {
    await PoolInstance.swap(
      tokenB.address,
      web3.utils.toWei("15", "ether"),
      web3.utils.toWei("5", "ether")
    );
  });

  it("Should  get Input Price With Fee", async () => {
    let price = await PoolInstance.getInputPriceWithFee(
      tokenB.address,
      web3.utils.toWei("1", "ether")
    );
  });

  it("Should give token A address", async () => {
    let tokenAddress = await PoolInstance.getTokenA();
    assert.equal(
      tokenAddress,
      tokenA.address,
      `token A address need to be ${tokenA.address} `
    );
  });

  it("Should give token B", async () => {
    let tokenAddress = await PoolInstance.getTokenB();
    assert.equal(
      tokenAddress,
      tokenB.address,
      `token B address need to be ${tokenB.address} `
    );
  });

  it("Should Give Balance Token", async () => {
    let balance = await PoolInstance.getBalanceToken(
      tokenA.address,
      contractAddress
    );
    console.log(web3.utils.fromWei(balance) + " tokenA");
  });
  it("Should give balance contract", async () => {
    let balanceContract = await PoolInstance.balanceContract();
    console.log(balanceContract + " BALANCE Contract");
  });
  it("Should add Liquidity to pool", async () => {
    await PoolInstance.addLiquidity(
      web3.utils.toWei("5", "ether"),
      web3.utils.toWei("10", "ether")
    );
    let balanceTokenA = await PoolInstance.getBalanceToken(
      tokenA.address,
      contractAddress
    );

    let balanceTokenB = await PoolInstance.getBalanceToken(
      tokenB.address,
      contractAddress
    );

    assert.equal(
      web3.utils.fromWei(balanceTokenA),
      507.5075,
      "token a need to be 507.5075"
    );
    assert.equal(
      web3.utils.fromWei(balanceTokenB),
      1005,
      "token b need to be 1005"
    );
  });
  it("Should return fees lp token by liquidity ", async () => {
    let result = await PoolInstance.calculationLpToken(
      web3.utils.toWei("1000", "ether"),
      web3.utils.toWei("3000", "ether")
    );
    console.log(result + " result fees lp");
  });

  it("Should transfer token to user", async () => {
    await PoolInstance.getBalanceToken(tokenA.address, accounts[1]);

    await PoolInstance.transferToken(
      tokenA.address,
      accounts[1],
      web3.utils.toWei("3", "ether")
    );
    let balanceTokenAfter = await PoolInstance.getBalanceToken(
      tokenA.address,
      accounts[1]
    );
    assert.equal(
      web3.utils.fromWei(balanceTokenAfter),
      3,
      "result need to be 3"
    );
  });
  it("Should swap token A to token B", async () => {
    await PoolInstance.swap(
      tokenA.address,
      web3.utils.toWei("15", "ether"),
      web3.utils.toWei("5", "ether")
    );
  });

});
