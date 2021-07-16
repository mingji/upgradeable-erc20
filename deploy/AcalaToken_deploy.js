module.exports = async ({ deployments }) => {
    const { deploy } = deployments;
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const implementation = await deploy("AcalaTokenImplementation", {
        from: deployer.address,
    });
    console.log("AcalaToken Implementation address:", implementation.address);

    const upgradeTokenArtifact = await deployments.getArtifact("AcalaTokenImplementation");
    const iface = new ethers.utils.Interface(JSON.stringify(upgradeTokenArtifact.abi));
    const data = iface.encodeFunctionData("initialize", [
        "AcalaToken", "ATC"
    ]);

    const proxy = await deploy("AcalaTokenProxy", {
        from: deployer.address,
        args: [
            implementation.address,
            process.env.PROXY_ADMIN_ADDRESS,
            data,
        ],
    });
    console.log("AcalaToken proxy address: ", proxy.address);
};
module.exports.tags = ["AcalaToken_deploy"];
