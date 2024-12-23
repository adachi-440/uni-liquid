// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { MessagingFee } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";

import { OFT } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/OFT.sol";
import {
    SendParam, MessagingReceipt, OFTReceipt
} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol";
import { OFTMsgCodec } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/libs/OFTMsgCodec.sol";
import { IOAppMsgInspector } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/interfaces/IOAppMsgInspector.sol";
import { IL2BridgeAdapter } from "../interfaces/IL2BridgeAdapter.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract UniLiquidOFT is OFT {

    event SwapCompleted(address indexed to, uint256 amount);

    uint32 public UNICHAIN_EID = 40333;

    constructor(
        string memory _name, // token name
        string memory _symbol, // token symbol
        address _layerZeroEndpoint, // local endpoint address
        address _owner // token owner used as a delegate in LayerZero Endpoint
    )
        OFT(_name, _symbol, _layerZeroEndpoint, _owner)
        Ownable(_owner)
    {
        // your contract logic here
        _mint(msg.sender, 100 ether); // mints 100 tokens to the deployer
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function _credit(
        address _to,
        uint256 _amountLD,
        uint32 _srcEid
    ) internal virtual override returns (uint256 amountReceivedLD) {
        if (_to == address(0x0)) _to = address(0xdead); // _mint(...) does notz support address(0x0)
        // @dev Default OFT mints on dst.
        _mint(_to, _amountLD);
        if (_srcEid == UNICHAIN_EID) emit SwapCompleted(_to, _amountLD);
        // @dev In the case of NON-default OFT, the _amountLD MIGHT not be == amountReceivedLD.
        return _amountLD;
    }
}
