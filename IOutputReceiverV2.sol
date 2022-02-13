// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity >=0.8.0;

import "./IOutputReceiver.sol";


/**
 * @title Provider interface for Revest FNFTs
 */
interface IOutputReceiverV2 is IOutputReceiver {

    /// Allows the passthrough of custom off-chain sourced data during the FNFT withdrawal process
    /// @param fnftId the fnftId for the FNFT being withdrawn from. Will typically map to internal data within implementing contracts
    /// @param owner the user who initiated the withdrawal and who should be transferred the value that the associated FNFT represents
    /// @param quantity the number of FNFTs which were just withdrawn from in this singular transaction. Will always be equal to or less than
    ///                 the total supply of FNFTs with this fnftId
    /// @param config the config associated with the FNFT 
    ///                 this config must be used, as at the point when this method is called, data within token vault may be deleted
    /// @param args arbitrary bytes data that should be decoded according to whatever methodology is specified within the implementing contract's metadata
    /// @dev Please note that this call should only be made by the contract located at addressRegistry.getRevest() and that when it is made
    ///      It is entirely possible that data in TokenVault will be have destroyed, making calls to getTokenVault().getFNFT(fnftId) no longer trustworthy
    function receiveSecondaryCallback(
        uint fnftId,
        address payable owner,
        uint quantity,
        IRevest.FNFTConfig memory config,
        bytes memory args
    ) external payable;

    /// Allows for the updating of FNFTs during their life-cycle without necessitating the use of an address lock
    /// Typically useful for claiming rewards on farmed positions or for triggering more complex value-based interactions without withdrawing underlying value
    /// @param fnftId the fnftId to trigger an update on
    /// @param args a bytes array that represents the data to utilize in the contract-specific update. Encoding order and type must be specified in metadata file
    /// @dev This function has a wide variety of uses, and even just passing in no data is often enough to claim tokens for the user making the call. Ensure that they 
    ///      own the FNFT they are making the update call on behalf of
    function triggerOutputReceiverUpdate(
        uint fnftId,
        bytes memory args
    ) external;

    /// This function should only ever be called when a split or additional deposit has occurred 
    /// It permits developers to handle circumstances where an FNFT has been copied to multiple different FNFTs
    /// and allows the OutputReceiver to also copy its data
    /// @param fnftId id for the original FNFT, typically will have data associated that needs copying
    /// @param newFNFTIds the new fnftIds to which internal contract data should be copied, in a non-referential manner
    /// @param caller the user who initiated this call via the Revest.sol entry point
    /// @param cleanup whether to delete the data stored at fnftId after copying to refund some gas
    /// @dev this function allows for the copying of data to new storage locations. 
    ///      If special handling is desired, use IOutputRecever v3 and utilize this call, made before more specific calls,
    ///      to flag the impacted fnftIds. ENSURE that msg.sender == addressProvider.getRevest()
    function handleFNFTRemaps(uint fnftId, uint[] memory newFNFTIds, address caller, bool cleanup) external;

}
