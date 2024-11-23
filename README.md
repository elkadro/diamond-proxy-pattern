# Diamond Proxy Pattern

## Overview

The **Diamond Proxy Pattern** is a comprehensive implementation of the diamond proxy architecture. This pattern allows developers to deploy upgradeable contracts efficiently and manage multiple facets of a contract seamlessly. The project includes a factory for deploying beacon proxies and upgrading them across multiple deployments. For example it can be used by a pool factory in an AMM to upgrade multiple pools at once.

## Features

- **Upgradeable Contracts**: Implements OpenZeppelin's `UpgradeableBeacon` for managing logic upgrades.
- **Scalable Deployment**: Deploy and manage thousands of proxies efficiently with a single beacon.
- **Customizable**: Provides flexibility for adapting to specific use cases.

## Prerequisites

This project depends on OpenZeppelin's `BeaconProxy` and `UpgradeableBeacon` contracts. Ensure you have the following dependency installed:

$bash
npm install @openzeppelin/contracts
$

## Installation

To install this repository as a package:

$bash
npm install diamond-proxy-pattern
$

## Example Usage

### Deploying the Factory

1. Deploy the `Factory` contract by providing the address of your logic contract:
   $solidity
   constructor(address _logic)
   $

2. Use the `deployPool()` function to create a new proxy. Each proxy will share the same logic contract.

### Upgrading the Logic Contract

To upgrade all deployed proxies, call the `updateBeaconLogic(address newLogic)` function with the new logic contract's address. This updates the beacon to point to the new implementation.

## Contract Structure

### Factory.sol
The factory contract provides functionality to:
- Deploy beacon proxies
- Manage multiple proxies
- Upgrade the logic contract across all proxies

### BeaconProxyManager.sol
Handles the creation and management of the beacon used for proxies. This contract abstracts away the complexities of beacon management.

## Examples

### Deploy a New Proxy
$solidity
address newProxy = factory.deployPool();
$

### Upgrade All Proxies
$solidity
factory.updateBeaconLogic(newLogicAddress);
$

### Retrieve All Proxies
$solidity
address[] memory allProxies = factory.getPoolsCount();
$

## Repository

- GitHub: [https://github.com/elkadro/diamond-proxy-pattern](https://github.com/elkadro/diamond-proxy-pattern)

## License

This project is licensed under the [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

## Contact

For questions or support, please reach out at:
- GitHub Issues: [https://github.com/elkadro/diamond-proxy-pattern/issues](https://github.com/elkadro/diamond-proxy-pattern/issues)
