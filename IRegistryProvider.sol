// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

interface IRegistryProvider {

    /// Helper function for changing the Address Registry should redeployment prove necessary
    /// Recommended to ensure adequate access controls for this method
    /// @param revestAddressRegistry the new address registry address
    function setAddressRegistry(address revestAddressRegistry) external;

    /// Returns the address for the Revest Address Registry contract on the current chain
    /// This should be set during contract creation
    /// @return address the address the AddressRegistry is located at
    function getAddressRegistry() external view returns (address);
}
