// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./GlassProfileNFT.sol";
import "./GlassPublicationNFT.sol";

contract GlassHub is Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _profileIdCounter;

  GlassProfileNFT public glassProfileNFT;
  GlassPublicationNFT public glassPublicationNFT;

  struct GlassProfileStruct {
    uint256 id;
    uint256 pubCount;
    uint256[] followers;
    uint256[] followings;
    GlassPublicationStruct[] publications;
    string handle;
    string uri;
  }

  struct GlassPublicationStruct {
    uint256 profileIdPointed;
    uint256 pubIdPointed;
    string contentURI;
  }

  mapping (address => GlassProfileStruct) public profiles;
  mapping (address => GlassPublicationStruct[]) public publications;

  function setModules(GlassProfileNFT _glassProfileNFT, GlassPublicationNFT _glassPublicationNFT) public onlyOwner {
    glassProfileNFT = _glassProfileNFT;
    glassPublicationNFT = _glassPublicationNFT;
  }

  function createProfile(string memory handle, string memory uri) public {
    require(glassProfileNFT.balanceOf(msg.sender) == 0, "PROFILE ALREADY CREATED");

    GlassProfileStruct storage profile = profiles[msg.sender];
    profile.pubCount = 0;
    profile.handle = handle;
    profile.uri = uri;
    profile.id = _profileIdCounter.current();
    _profileIdCounter.increment();

    glassProfileNFT.safeMint(msg.sender, uri);
  }

  function postPublication(string memory uri) public {
    require(glassProfileNFT.balanceOf(msg.sender) == 1, "NO PROFILE");

    GlassProfileStruct storage profile = profiles[msg.sender];
    profile.pubCount += 1;

    GlassPublicationStruct memory publication;
    publication.contentURI = uri;
    publication.profileIdPointed = profile.id;

    profile.publications.push(publication);
    publications[msg.sender].push(publication);

    glassPublicationNFT.safeMint(msg.sender, uri);
  }

  function followProfile(address profileAddress) public {
    require(glassProfileNFT.balanceOf(msg.sender) == 1, "NO PROFILE");

    uint256 followingId = profiles[profileAddress].id;

    GlassProfileStruct storage profile = profiles[msg.sender];
    profile.followings.push(followingId);

    profiles[profileAddress].followers.push(profile.id);
  }
}