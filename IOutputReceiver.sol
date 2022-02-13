// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity >=0.8.0;

import "./IRegistryProvider.sol";
import './IERC165.sol';

/**
 * @title Provider interface for Revest FNFTs
 *
 */
interface IOutputReceiver is IRegistryProvider, IERC165 {

    /// The callback function called by the Revest core system when a withdrawal is made from an FNFT that 
    /// has its 'outputReceiver' variable set to an implementation of this interface
    /// @param fnftId the fnftId that maps to info about the FNFT which was just withdrawn from
    /// @param asset the underlying asset which was stored in the FNFT. For pure signal cases, this will often be address(0)
    ///              and further information about the true-underlying asset should be stored in contracts implementing this interface
    /// @param owner the address which initiated the withdrawal transaction
    /// @param quantity the number of FNFTs which were just withdrawn from in this singular transaction. Will always be equal to or less than
    ///                 the total supply of FNFTs with this fnftId
    /// @dev this function will always be called when a withdrawal succeeds which has its value routed to a contract implementing this interface
    ///      this function allows the implementing contract to be aware that an FNFT of a given ID has been withdrawn from, what asset it contained,
    ///      how many of those FNFTs were withdrawn, and how much value the implementing contract has received as a result of this transaction
    function receiveRevestOutput(
        uint fnftId,
        address asset,
        address payable owner,
        uint quantity
    ) external;

    /// Returns a URL pointing to a metadata file which describes how to decode encoded data pulled from this contract
    /// and utilize it in displaying on-chain information about the fnftId specified to the frontend
    /// @param fnftId the fnftId that maps to info about the FNFT this contract will eventually receive a signal from
    /// @dev this function is used by the frontend to learn how to decode the data it receives from getOutputDisplayValue
    /// @return a URL to find the necessary JSON config at. See additional documentation for further info on the JSON configs
    function getCustomMetadata(uint fnftId) external view returns (string memory);

    /// Gets the value respresnted by the passed-in fnftId - useful when dealing with signal FNFTs
    /// @param fnftId the fnftId that maps to info about the FNFT this contract will eventually receive a signal from
    /// @dev this function is called by the TokenVault method getFNFTCurrentValue to display the current value an FNFT contains
    ///      this function is particularly useful if a contract implementing this interface contains the real underlying asset and is
    ///      primarily geared to utilize the FNFT for signaling purposes (asset = address(0), depositAmount = 0)
    /// @return an integer representing the underlying value
    function getValue(uint fnftId) external view returns (uint);

    /// Gets the underlying asset that the passed fnftId represents within a contract implementing this interface 
    /// @param fnftId the fnftId that maps to info about the FNFT this contract will eventually receive a signal from
    /// @dev this function is useful in similar cases to the getValue function proceeding it and can be called by the frontend
    ///      to easily parse decimals or retreive similar information about the true underlying asset mapped to an FNFT using 
    /// @return an address representing the underlying that the passed-in fnftId represents a signal for
    function getAsset(uint fnftId) external view returns (address);

    /// Retrieves abi.encoded values to display on the frontend 
    /// @param fnftId the fnftId that maps to info about the FNFT this contract will eventually receive a signal from
    /// @dev this function encodes desired information into a bytes array that can be decoded by the frontend to display arbitrary
    ///      parameters and values into useful information that should be shared with the owner of this FNFT
    /// @return a bytes array that can be decoded by the frontend according to the schema specified in the JSON file 
    ///         provided by getCustomMetadata
    function getOutputDisplayValues(uint fnftId) external view returns (bytes memory);

}
