// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BaseHook} from "v4-periphery/src/base/hooks/BaseHook.sol";

import {Hooks} from "v4-core/src/libraries/Hooks.sol";
import {IPoolManager} from "v4-core/src/interfaces/IPoolManager.sol";
import {PoolKey} from "v4-core/src/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "v4-core/src/types/PoolId.sol";
import {BalanceDelta} from "v4-core/src/types/BalanceDelta.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "v4-core/src/types/BeforeSwapDelta.sol";
import { OptionsBuilder } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";
import { IOFT, SendParam } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol";
import { MessagingFee } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";
import { Currency } from "v4-core/src/types/Currency.sol";

contract UniLiquidHook is BaseHook {
    using OptionsBuilder for bytes;
    using PoolIdLibrary for PoolKey;

    // NOTE: ---------------------------------------------------------
    // state variables should typically be unique to a pool
    // a single hook contract should be able to service multiple pools
    // ---------------------------------------------------------------

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {}

    function getHookPermissions() public pure override returns (Hooks.Permissions memory) {
        return Hooks.Permissions({
            beforeInitialize: false,
            afterInitialize: false,
            beforeAddLiquidity: false,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: false,
            afterRemoveLiquidity: false,
            beforeSwap: false,
            afterSwap: true,
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });
    }

    // -----------------------------------------------
    // NOTE: see IHooks.sol for function documentation
    // -----------------------------------------------

    function afterSwap(address, PoolKey calldata key, IPoolManager.SwapParams calldata swapParams, BalanceDelta delta, bytes calldata hookData)
        external
        override
        returns (bytes4, int128)
    {
        uint256 bridgeTokenMintAmount;
        if (swapParams.amountSpecified > 0) {
            bridgeTokenMintAmount = uint256(int256(-delta.amount0()));
        } else {
            bridgeTokenMintAmount = uint256(-swapParams.amountSpecified);
        }

        bytes memory option = OptionsBuilder.newOptions().addExecutorLzReceiveOption(200_000, 0);

        address bridgeTokenAddr;
        if (swapParams.zeroForOne) {
            bridgeTokenAddr = Currency.unwrap(key.currency0);
        } else {
            bridgeTokenAddr = Currency.unwrap(key.currency1);
        }
        IOFT bridgeToken = IOFT(bridgeTokenAddr);

        address toAddr = hookData.to;
        uint32 dstEid = hookData.dstEid;

        SendParam memory sendParam =
            SendParam(dstEid, bytes32(uint256(uint160(toAddr))), bridgeTokenMintAmount, bridgeTokenMintAmount, option, "", "");
        MessagingFee memory msgFee = bridgeToken.quoteSend(sendParam, false);
        bridgeToken.send{ value: msgFee.nativeFee }(sendParam, msgFee, msg.sender);

        return (BaseHook.afterSwap.selector, 0);
    }
}
