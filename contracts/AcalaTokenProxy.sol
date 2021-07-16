// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "@openzeppelin/contracts/proxy/TransparentUpgradeableProxy.sol";

contract AcalaTokenProxy is TransparentUpgradeableProxy {
    bool public killedUpgradeable;

    constructor(address logic, address admin, bytes memory data) TransparentUpgradeableProxy(logic, admin, data) public {
        killedUpgradeable = false;
    }

    function _upgradeTo(address newImplementation) internal override(UpgradeableProxy) {
        require(!killedUpgradeable, 'Already killed upgradable');
        UpgradeableProxy._upgradeTo(newImplementation);
    }

    function killUpgrade() external ifAdmin {
        require(!killedUpgradeable, 'Already killed upgradable');
        killedUpgradeable = true;
    }
    uint256[49] private __gap;
}