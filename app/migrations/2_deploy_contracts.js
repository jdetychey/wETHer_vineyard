module.exports = function(deployer) {
  deployer.deploy(InsuranceLib);
  deployer.autolink();
  deployer.deploy(InsurancePool);
};
