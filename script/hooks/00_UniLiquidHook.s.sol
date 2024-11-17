// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {Hooks} from "v4-core/src/libraries/Hooks.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";

import {Constants} from "./base/Constants.sol";
import {UniLiquidHook} from "../../src/hooks/UniLiquidHook.sol";
import {HookMiner} from "../../test/hooks/utils/HookMiner.sol";

/// @notice Mines the address and deploys the UniLiquidHook.sol Hook contract
contract UniLiquidHookScript is Script, Constants {
    function setUp() public {}

    function run() public {
        // hook contracts must have specific flags encoded in the address
        uint160 flags = uint160(Hooks.AFTER_SWAP_FLAG);

        // Mine a salt that will produce a hook address with the correct flags
        bytes memory constructorArgs = abi.encode(POOLMANAGER);
        (address hookAddress, bytes32 salt) =
            HookMiner.find(CREATE2_DEPLOYER, flags, type(UniLiquidHook).creationCode, constructorArgs);

        // Deploy the hook using CREATE2
        vm.broadcast();
        UniLiquidHook hook = new UniLiquidHook{salt: salt}(IPoolManager(POOLMANAGER));
        console.log("contract address:", address(hook));
        require(address(hook) == hookAddress, "UniLiquidHookScript: hook address mismatch");
    }
}
