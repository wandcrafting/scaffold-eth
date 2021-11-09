module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy("YourToken", {
    from: deployer,
    log: true,
  });

  const yourToken = await ethers.getContract("YourToken", deployer)
  //const result = await yourToken.transfer("0x5cdD68A64C1bfF7eCd276cfc0532db7B15be9a86", ethers.utils.parseEther("1000"));
};
module.exports.tags = ["YourToken"];
