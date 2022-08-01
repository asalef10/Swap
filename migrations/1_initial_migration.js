
const PoolFactory = artifacts.require("PoolFactory");

module.exports = function (deployer) {
  deployer.deploy(PoolFactory);
};
