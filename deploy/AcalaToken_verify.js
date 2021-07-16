const { ethers, run } = require("hardhat");

module.exports = async ({ deployments }) => {
    const implementation = await ethers.getContract("AcalaTokenImplementation");
    try {
        await run("verify:verify", {
            address: implementation.address,
            contract: "contracts/AcalaTokenImplementation.sol:AcalaTokenImplementation",
        });
    } catch (e) {
        console.log(0, e);
    }

    const upgradeTokenArtifact = await deployments.getArtifact("AcalaTokenImplementation");
    const iface = new ethers.utils.Interface(JSON.stringify(upgradeTokenArtifact.abi));
    const data = iface.encodeFunctionData("initialize", [
        "AcalaToken", "ATC"
    ]);
    const proxy = await ethers.getContract("AcalaTokenProxy");
    try {

        await run("verify:verify", {
            address: proxy.address,
            constructorArguments: [
                implementation.address,
                process.env.PROXY_ADMIN_ADDRESS,
                data,
            ],
            contract: "contracts/AcalaTokenProxy.sol:AcalaTokenProxy",
        });
    } catch (e) {
        console.log(1, e);
    }
};
module.exports.tags = ["AcalaToken_verify"];
