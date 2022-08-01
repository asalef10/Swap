
const SwapToken = artifacts.require("SwapToken");

module.exports = function (deployer) {
  deployer.deploy(SwapToken);
};
