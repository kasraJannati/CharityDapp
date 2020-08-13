const CharityApp = artifacts.require("./CharityApp.sol");

module.exports = function(deployer) {
  deployer.deploy(CharityApp, '0xbC86Ea436E2Ab3Fcf4105335c0C08bBdd3266A55', 1000000000000000);
};