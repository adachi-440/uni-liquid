// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {IHooks} from "v4-core/src/interfaces/IHooks.sol";
import {Currency} from "v4-core/src/types/Currency.sol";

/// @notice Shared configuration between scripts
contract Config {
    IERC20 constant token0 = IERC20(address(0x27d1C35Dc5672dFa6d6c9CAD35C0B29298377202)); // mWETH
    IERC20 constant token1 = IERC20(address(0x3C2E47b89633738454C499118E4a79cF78C4Ea68)); // mDAI
    IHooks constant hookContract = IHooks(address(0x2D2486a99184d55dAdf2968A780A85680c798040));

    // previous Anvil value
    // IERC20 constant token0 = IERC20(address(0x0165878A594ca255338adfa4d48449f69242Eb8F));
    // IERC20 constant token1 = IERC20(address(0xa513E6E4b8f2a923D98304ec87F64353C4D5C853));
    // IHooks constant hookContract = IHooks(address(0x0));

    Currency constant currency0 = Currency.wrap(address(token0));
    Currency constant currency1 = Currency.wrap(address(token1));
}
