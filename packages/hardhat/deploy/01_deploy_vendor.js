module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const yourToken = await ethers.getContract("YourToken", deployer);

  await deploy("Vendor", {
   from: deployer,
   args: [yourToken.address],
   log: true,
  });
  const Vendor = await deployments.get("Vendor");
  const vendor = await ethers.getContract("Vendor", deployer);
  console.log("\n 🏵  Sending all 1000 tokens to the vendor...\n");

  const result = await yourToken.transfer(vendor.address, ethers.utils.parseEther("1000"));

  console.log("\n 🤹  Sending ownership to frontend address...\n")
  await vendor.transferOwnership("0x5cdD68A64C1bfF7eCd276cfc0532db7B15be9a86");
};

module.exports.tags = ["Vendor"];
