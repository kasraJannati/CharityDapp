const CharityApp = artifacts.require("./CharityApp.sol");

module.exports = function(deployer) {
  deployer.deploy(CharityApp, '0x8544d5BB000f86fDCd0B75B8A37C6039d1Df3793', 1000000000000000000);
};