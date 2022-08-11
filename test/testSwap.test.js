const Pool = artifacts.require("Pool");
const PoolFactory = artifacts.require("PoolFactory");

const ERC20 = artifacts.require("ERC20PresetFixedSupply");

contract("Pool", (accounts) => {
  function fromWeiToNumber(number) {
    return parseFloat(web3.utils.fromWei(number, "ether")).toFixed(6) * 1;
  }

  const A_PRICE = 1;
  const B_PRICE = 3;
  const C_PRICE = 6;

  let tokenA, tokenB, tokenC;

  const issueAmount = web3.utils.toWei("100000000000000", "ether");

  let PoolInstance, PoolFactoryInstance;

  before(async () => {
    tokenA = await ERC20.new("tokenA", "A", issueAmount, accounts[0]);

    tokenB = await ERC20.new("tokenB", "B", issueAmount, accounts[0]);

    tokenC = await ERC20.new("tokenC", "C", issueAmount, accounts[0]);

    PoolFactoryInstance = await PoolFactory.deployed();

    //create pool A/B with 10,000 A and equivalent B
    let AInput = 10000 * A_PRICE;
    let BInput = (B_PRICE / A_PRICE) * AInput;

    await PoolFactoryInstance.createPool(tokenA.address, tokenB.address);

    let abAddress = await PoolFactoryInstance.getPool(
      tokenA.address,
      tokenB.address
    );

    PoolInstance = await Pool.at(abAddress);

    await tokenA.approve(PoolInstance.address, issueAmount);
    await tokenB.approve(PoolInstance.address, issueAmount);
    await tokenC.approve(PoolInstance.address, issueAmount);

    //create pool A/C
    //create pool A/B with 10,000 A and equivalent C

    let CInput = (C_PRICE / A_PRICE) * AInput;
    await PoolFactoryInstance.createPool(tokenA.address, tokenC.address);

    //create pool B/C
    //create pool B/C with 10,000 B and equivalent C
    BInput = 20000 * B_PRICE;
    CInput = (C_PRICE / B_PRICE) * BInput;
    await PoolFactoryInstance.createPool(tokenB.address, tokenC.address);

    let acAddress = await PoolFactoryInstance.getPool(
      tokenA.address,
      tokenC.address
    );

    let bcAddress = await PoolFactoryInstance.getPool(
      tokenB.address,
      tokenC.address
    );

    await tokenA.transfer(abAddress, web3.utils.toWei("500", "ether"));
    await tokenB.transfer(abAddress, web3.utils.toWei("1000", "ether"));
  });

  it("Should swap token A to token B", async () => {
    let tokenBBefore = await tokenB.balanceOf(accounts[0]);
    let tokenABefore = await tokenA.balanceOf(accounts[0]);

    let balanceBefore = await PoolInstance.balanceContract();
    console.log(balanceBefore + "  balanceBefore");

    await PoolInstance.swap(tokenB.address, web3.utils.toWei("5", "ether"));
    let balanceAfter = await PoolInstance.balanceContract();
    console.log(balanceAfter + "  balanceAfter");
    

    let tokenBAfter = await tokenB.balanceOf(accounts[0]);
    let tokenAAfter = await tokenA.balanceOf(accounts[0]);

    // console.log("tokenABefore " + tokenABefore);
    // console.log("tokenAAfter " + tokenAAfter);

    // console.log("tokenBBefore " + tokenBBefore);
    // console.log("tokenBAfter " + tokenBAfter);
  });

  it("Should  get Input Price With Fee", async () => {
    let price = await PoolInstance.getInputPriceWithFee(
      tokenB.address,
      web3.utils.toWei("1", "ether")
    );
    console.log(JSON.stringify(web3.utils.fromWei(price.inputAmount)) + "price token");
  });

  it("Should give token A", async () => {
    let tokenA = await PoolInstance.getTokenA();
    //  console.log(tokenA + " token a");
  });

  it("Should give token B", async () => {
    let tokenB = await PoolInstance.getTokenB();
    // console.log(tokenB + " token b");
  });
  it("Should give owner and balance  ", async () => {
    // let balance = await PoolInstance.getOwnerAndBalance();
    // console.log(JSON.stringify(balance) + "  balanceOwner");
  });
  
});
