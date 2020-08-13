const CharityApp = artifacts.require("./CharityApp.sol");

module.exports = function(deployer) {
  deployer.deploy(CharityApp, '0xa1785BB0bbd1fFEe49d584d8539D232ba78dC622', 1000000000000);
};