// SPDX-License-Identifier: CC-BY-4.0
pragma solidity 0.8.20;

import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

/**
 * @title BeaconProxyManager
 * @dev Handles the deployment and management of proxy beacons
 * @author @elkadro
 * @license CC-BY-4.0
 */
contract BeaconProxyManager {
    bool private beaconInitialized;
    UpgradeableBeacon private beaconInstance;

    event BeaconCreated(address indexed beaconAddress);

    /**
     * @dev Deploys a new proxy, initializes the beacon if not already created, and returns the proxy address.
     * @param implementation The logic contract address.
     * @param initializerData Data to call on initialization.
     * @return address The deployed proxy address.
     */
    function createBeaconProxy(address implementation, bytes memory initializerData) internal returns (address) {
        if (!beaconInitialized) {
            _initializeBeacon(implementation);
        }
        address payable proxyAddress;
        bytes memory proxyCode = type(BeaconProxy).creationCode;
        bytes memory fullCode = abi.encodePacked(proxyCode, abi.encode(address(beaconInstance), initializerData));

        // solhint-disable-next-line no-inline-assembly
        assembly {
            proxyAddress := create(0, add(fullCode, 0x20), mload(fullCode))
            if iszero(extcodesize(proxyAddress)) {
                revert(0, 0)
            }
        }
        return address(proxyAddress);
    }

    /**
     * @dev Initializes a new beacon pointing to the specified logic contract.
     * @param implementation The logic contract address.
     */
    function _initializeBeacon(address implementation) internal {
        if (!beaconInitialized) {
            beaconInstance = new UpgradeableBeacon(implementation);
            beaconInitialized = true;
            emit BeaconCreated(address(beaconInstance));
        }
    }

    /**
     * @dev Upgrades the beacon to a new logic contract address.
     * @param newImplementation The new logic contract address.
     */
    function updateBeaconLogic(address newImplementation) internal {
        beaconInstance.upgradeTo(newImplementation);
    }

    /**
     * @dev Returns the current beacon address.
     * @return address The address of the beacon contract.
     */
    function getBeacon() external view returns (address) {
        return address(beaconInstance);
    }
}