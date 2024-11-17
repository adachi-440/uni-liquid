// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
/// @notice Interface for the callback executed when an address unlocks the pool manager
interface IUnlockCallback {
    /// @notice Called by the pool manager on msg.sender when the manager is unlocked
    /// @param data The data that was passed to the call to unlock
    /// @return Any data that you want to be returned from the unlock call
    function unlockCallback(bytes calldata data) external returns (bytes memory);
}

interface IPoolManager {
    function unlock(bytes calldata data) external returns (bytes memory result);
}


contract Unlock {
    address constant poolManager = 0x294FC2d876e80C8c99622613A20a64Bd8e487621;
    function unlockCallback(bytes calldata data) external returns (bytes memory){
        return IPoolManager(poolManager).unlock(data);
    }
}
