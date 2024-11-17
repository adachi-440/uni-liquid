// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {PositionManager} from "v4-periphery/src/PositionManager.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";

/// @notice Shared constants used in scripts
contract Constants {
    // address constant CREATE2_DEPLOYER = address(0x4e59b44847b379578588920cA78FbF26c0B4956C); // existing
    address constant CREATE2_DEPLOYER = address(0xae691Bb9a65FaD0835E5f095Cc8c2e62a7c6E2FF); // sepolia testnet

    // IPoolManager constant POOLMANAGER = IPoolManager(address(0x5FbDB2315678afecb367f032d93F642f64180aa3)); // exiting
    // PositionManager constant posm = PositionManager(payable(address(0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0))); // exiting
    // IAllowanceTransfer constant PERMIT2 = IAllowanceTransfer(address(0x000000000022D473030F116dDEE9F6B43aC78BA3)); // exiting

    IPoolManager constant POOLMANAGER = IPoolManager(address(0x294FC2d876e80C8c99622613A20a64Bd8e487621)); // sepolia testnet
    PositionManager constant posm = PositionManager(payable(address(0x95da29D23484dAc98Ae29D109a26e3e8B3d46944))); // sepolia testnet
    IAllowanceTransfer constant PERMIT2 = IAllowanceTransfer(address(0xB952578f3520EE8Ea45b7914994dcf4702cEe578)); // sepolia testnet
}
