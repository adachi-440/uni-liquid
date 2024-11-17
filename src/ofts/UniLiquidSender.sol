// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

import { IOFT, SendParam } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol";
import { MessagingFee } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";

/**
 * @notice THIS IS AN EXAMPLE CONTRACT. DO NOT USE THIS CODE IN PRODUCTION.
 */

contract UniLiquidSender {
    using OptionsBuilder for bytes;

    event MessageSent(string message, uint32 dstEid);

    struct SwapParams {
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        bytes hookData; // chainid encoded as bytes
        // address hooks;
        // int24 tickSpacing;
        // uint24 fee;
    }

    /// The _options variable is typically provided as an argument to both the _quote and _lzSend functions.
    /// In this example, we demonstrate how to generate the bytes value for _options and pass it manually.
    /// The OptionsBuilder is used to create new options and add an executor option for LzReceive with specified parameters.
    /// An off-chain equivalent can be found under 'Message Execution Options' in the LayerZero V2 Documentation.
    bytes _options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(50000, 0);

    constructor(){}

    function bridge(address bridgeTokenAddr, uint256 amount)
        external
        returns (bool)
    {
        bytes memory option = OptionsBuilder.newOptions().addExecutorLzReceiveOption(200_000, 0);

        IOFT bridgeToken = IOFT(bridgeTokenAddr);

        address toAddr = 0x1B9203Eeb68EF5fe62Ad38f0E4d22990687E6585;

        uint32 dstEid = 40333;

        SendParam memory sendParam =
            SendParam(dstEid, bytes32(uint256(uint160(toAddr))), amount, amount, option, "", "");
        MessagingFee memory msgFee = bridgeToken.quoteSend(sendParam, false);
        bridgeToken.send{ value: msgFee.nativeFee }(sendParam, msgFee, msg.sender);

        return true;
    }
}
