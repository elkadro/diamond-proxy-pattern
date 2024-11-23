// SPDX-License-Identifier: CC-BY-4.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ProxyBeaconManager.sol";

/**
 * @title ProxyFactory
 * @dev Factory contract to deploy and manage beacon proxies with upgradable logic over any implementation contract you have.
 * @notice: Allows mass upgrades across all deployed proxies.
 * @license CC-BY-4.0
 */

contract ProxyFactory is Ownable, ProxyBeaconManager {
    address private implementationContract;
    uint256 private implementationVersion;
    address[] private deployedProxies;

    event ProxyDeployed(address indexed deployer, address indexed proxy, uint256 indexed proxyIndex);
    event ProxiesUpgraded(address indexed upgrader, address indexed newImplementation);

    constructor(address _implementation) {
        require(_implementation != address(0), "ZERO_ADDRESS");
        implementationContract = _implementation;
        implementationVersion = 1;
    }

    /**
     * @dev Deploys a new proxy using the beacon.
     * @return address of the newly created proxy.
     */
    function deployProxy() external onlyOwner returns (address) {
        // Add requires and data manipulation

        // Create a new proxy
        address proxy = createBeaconProxy(implementationContract, "");
        deployedProxies.push(proxy);

        emit ProxyDeployed(msg.sender, proxy, deployedProxies.length - 1);

        // IMPORTANT: Initialize the proxy with your data
        // ILOGIC(proxy).initialize(poolData);

        return proxy;
    }

    /**
     * @dev Returns the proxy address at a given index.
     * @param index The index of the proxy.
     * @return address of the proxy.
     */
    function getProxy(uint256 index) external view returns (address) {
        return deployedProxies[index];
    }

    /**
     * @dev Returns the total number of proxies deployed by the factory.
     * @return uint256 count of deployed proxies.
     */
    function getProxyCount() external view returns (uint256) {
        return deployedProxies.length;
    }

    /**
     * @dev Updates the beacon logic contract and increments the version.
     * @param newImplementation The address of the new logic contract.
     */
    function updateImplementation(address newImplementation) external onlyOwner {
        require(newImplementation != address(0), "ZERO_ADDRESS");

        emit ProxiesUpgraded(msg.sender, newImplementation);

        implementationContract = newImplementation;
        ++implementationVersion;

        updateBeaconLogic(newImplementation);
    }

    /**
     * @dev Returns the current version of the implementation logic.
     * @return uint256 current implementation version.
     */
    function getImplementationVersion() external view returns (uint256) {
        return implementationVersion;
    }
}
