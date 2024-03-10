

// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
/// ZEPPELIN CODE amended for use 

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title Dynamic Token
 * @dev An ERC1155 token contract with dynamic metadata evolution functionality
 */
contract DynamicToken is ERC1155, AccessControl {
    // no need for a minter role cuz anyone can mint
    bytes32 public constant EVOLVER_ROLE = keccak256("EVOLVER_ROLE");

    // my address is 0xfF37d103d038bBca1837B43A848BB9221b1B0004
        // if i was pretending to store the metadata off chain, i would use the following URI or the IPFS equivalent
        // ERC1155("www.testcoolreward.com/base")
        // but im storing it on chain for now as it evolves
    constructor(address defaultAdmin) ERC1155("")
    {
        _setupRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _setupRole(EVOLVER_ROLE, defaultAdmin);
    }

    // Event to emit when metadata evolves
    event RewardChanged(uint256 indexed tokenId, string newMetadata, address evolver);

    /**
     * @dev Mint new tokens - callable by anyone
     * @param account The address to mint tokens to
     * @param id The ID of the token to mint
     * @param amount The amount of tokens to mint - will usually be 1? but this gives flexibility
     * @param data for the metadata or anything else later
     */
    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
    {
        _mint(account, id, amount, data);
    }
    
    /**
     * @dev Evolve function - to upgrade the NFT metadata - restricted to evolver roles.
     * @notice Base token has no rewards, but as the user earns rewards, the metadata is updated with this function
     * @param _tokenId The ID of the token to change metadata for
     * @param _newMetadata The new metadata
     */
    function evolve(uint256 _tokenId, string memory _newMetadata) external {
        // only by those that have role access
        require(hasRole(EVOLVER_ROLE, msg.sender), "Caller is not an evolver");
        require(bytes(_newMetadata).length > 0, "Metadata cannot be empty");
        
        tokenMetadata[_tokenId] = _newMetadata;
        // emit event to show what token's reward has been updated, to what and by whom
        emit RewardChanged(_tokenId, _newMetadata, msg.sender);
    }

    /**
     * @dev Grant the evolver role to an address.
     * @param _address The address to grant the evolver role to.
     */
    function grantEvolverRole(address _address) external {
        // grant the evolver role to the address, if you are admin
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not an admin");
        grantRole(EVOLVER_ROLE, _address);
    }

    /**
     * @dev Revoke the evolver role from an address.
     * @param _address The address to revoke the evolver role from.
     */
    function revokeEvolverRole(address _address) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not an admin");
        revokeRole(EVOLVER_ROLE, _address);
    }

    // Mapping from token ID to metadata
    mapping(uint256 => string) public tokenMetadata;

    /**
     * @dev Get the metadata, ie the reward, associated with a token ID
     * @param _tokenId The ID of the token
     * @return The metadata (ie, the reward) held by the token
     */
    function getMetadata(uint256 _tokenId) external view returns (string memory) {
        return tokenMetadata[_tokenId];
    }
}
