// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity >=0.8.0;

import "./IOutputReceiverV2.sol";


/**
 * @title Provides interface for Revest FNFTs
 */
interface IOutputReceiverV3 is IOutputReceiverV2 {

    /// Specific call to allow the implementing contract to handle time-locked FNFTs having their maturity extended
    /// Particularly useful for contract where staking is the aim
    /// @param fnftId the id for the FNFT having its maturity extended
    /// @param expiration the date in UTC to which the FNFT has had its maturity extended
    /// @param caller the user who initiated the call via Revest.sol
    /// @dev This method is useful for adjusting lockup-period based values, such as Curve integrations
    ///      ENSURE msg.sender == addressRegistry.getRevest()
    function handleTimelockExtensions(uint fnftId, uint expiration, address caller) external;

    /// Specific call to allow handling of additional deposits to an FNFT which has additional deposits enabled
    /// @param fnftId the id for the FNFT having an additional deposit made to it
    /// @param amountToDeposit the amount to deposit into the FNFT. This call will be made after values in TokenVault have been
    ///                        adjusted, meaning that to get the original amount in TokenVault, this should be subtracted
    ///                        from the result of calling TokenVault.getFNFT(fnftId).depositAmount
    /// @param quantity the quantity of FNFTs having additional deposits made into them. Useless for singular FNFTs
    /// @param caller the user who initiated the call via Revest.sol
    /// @dev this method is useful for allowing additional deposits via the typical Revest UI, particularly in cases where tokens are
    ///      non-standard and not stored in TokenVault – users will need to be communicated to that additional approvals are required via
    ///      the metadata file
    ///      ENSURE msg.sender == addressRegistry.getRevest()
    function handleAdditionalDeposit(uint fnftId, uint amountToDeposit, uint quantity, address caller) external;

    /// Specific call to allow handling of splitting FNFTs which have splitting enabled
    /// @param fnftId the id for the FNFT being split into multiple different FNFTs – ids for the resulting additional FNFTs will have
    ///               been provided in the previous remapFNFT call
    /// @param quantity the quantity of FNFTs being split into multiple different FNFTs
    /// @param caller the user who initiated the call via Revest.sol
    /// @dev this method allows splitting more complex positions into smaller ones, and will usually be difficult to implement
    ///      care is recommended in implementing this function
    ///      ENSURE msg.sender == addressRegistry.getRevest()
    function handleSplitOperation(uint fnftId, uint[] memory proportions, uint quantity, address caller) external;

}
