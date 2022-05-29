<img src="./assets/logo.png" width="150" align="right" alt="" />

# 👁️ Glass Smart Contracts

## Overview

Although Glass is positioning itself as a social etherscan we want to give users the ability to share and create content directly on the service. To do this, we use an iterative (see Upgradeability) system, which in the basic version includes smart contracts for Profiles and Publications. This system is inspired by the Lens Protocol, but is not a complete version of it or a replacement, as the future plans are to integrate Lens into Glass, and the gradual evolution of Glass

How it all works:

### Profiles

Any address can create a profile and receive an ERC-721 `Glass Profile` NFT. Wallets automatically get Profile NFT when they first post/follow. Profiles are represented by a `ProfileStruct`:

```
/**
 * @notice A struct containing profile data.
 *
 * @param pubCount The number of publications made to this profile.
 * @param followNFT The address of the followNFT associated with this profile, can be empty.
 * @param handle The profile's associated handle.
 * @param uri The URI to be displayed for the profile NFT.
 */
struct GlassProfileStruct {
    uint256 id;
    uint256 pubCount;
    uint256[] followers;
    uint256[] followings;
    GlassPublicationStruct[] publications;
    string handle;
    string uri;
}
```

Profiles have a specific URI associated with them, which is meant to include metadata, such as a link to a profile picture or a display name for instance, the JSON standard for this URI is not yet determined. Profile owners can always change their profile URI.

#### Follows

Wallets can follow profiles and receiving a `Follow NFT`. Each profile has a connected, unique `FollowNFT` contract, which is first deployed upon successful follow.

### Publications

Profile owners can `publish` to any profile they own.

Publications are on-chain content created and published via profiles.

```
/**
 * @notice A struct containing data associated with each new publication.
 *
 * @param profileIdPointed The profile token ID this publication points to.
 * @param pubIdPointed The publication ID this publication points to, for comments, can be empty.
 * @param contentURI The URI associated with this publication.
 */
struct GlassPublicationStruct {
    uint256 profileIdPointed;
    uint256 pubIdPointed;
    string contentURI;
}
```

##### Post

This is the standard publication type, akin to a regular post on traditional social media platforms. Posts contain:

1. A URI, pointing to the actual publication body's metadata JSON, including any images or text.
2. An uninitialized pubIdPointed, since they are only needed in comments.

##### Comment

This is a publication type that points back to another publication, akin to a regular comment on traditional social media. Comments contain:

1. A URI, just like posts, pointing to the publication body's metadata JSON.
2. An initialized pubIdPointed, containing the publication ID of the publication commented on.

## Contribution

Interested in contributing to the Glass? Thanks so much for your interest! We are always looking for improvements to the project and contributions from open-source developers are greatly appreciated.

If you have a contribution in mind, please open issue or PR with your ideas.

## Setup

This project was bootstrapped from hardhat.

Try running some of the following tasks:

```shell
npx hardhat compile
npx hardhat test
npx hardhat run scripts/deploy.ts --network testnet_aurora
npx hardhat run scripts/upgrade.ts --network testnet_aurora
```
