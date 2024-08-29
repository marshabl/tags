// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Tags {
    // State variables
    string private _name;
    string private _symbol;
    uint256 private _totalTags;
    bool private _revokable;
    bool private _transferable;

    // Mapping of addresses to a boolean (true if tagged, false if not)
    mapping(address => bool) private _tags;

    // Address of the contract creator
    address private _creator;

    // Events
    event Tag(address indexed user, bool status);
    event Revoke(address indexed user, bool status);
    event Transfer(address indexed from, address indexed to, bool status);

    // Constructor to initialize the contract
    constructor(string memory name_, string memory symbol_, bool revokable_, bool transferable_) {
        _name = name_;
        _symbol = symbol_;
        _revokable = revokable_;
        _transferable = transferable_;
        _creator = msg.sender;
    }

    // Function to get the name of the token
    function name() public view returns (string memory) {
        return _name;
    }

    // Function to get the symbol of the token
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    // Function to get the total supply of tags
    function totalTags() public view returns (uint256) {
        return _totalTags;
    }

    // Function to check if the contract allows revoking tags
    function revokable() public view returns (bool) {
        return _revokable;
    }

    // Function to check if the contract allows transferring tags
    function transferable() public view returns (bool) {
        return _transferable;
    }

    // Function to check if an address is tagged
    function isTagged(address user) public view returns (bool) {
        return _tags[user];
    }

    // Function to tag an address, only callable by the contract creator
    function tag(address user) public {
        require(msg.sender == _creator, "Only the contract creator can tag");
        require(!_tags[user], "User is already tagged");

        _tags[user] = true;
        _totalTags += 1;

        emit Tag(user, true);
    }

    // Function to revoke a tag from an address, only callable by the contract creator
    function revoke(address user) public {
        require(msg.sender == _creator, "Only the contract creator can revoke");
        require(_tags[user], "User is not tagged");
        require(_revokable, "Revoking is not allowed");

        _tags[user] = false;
        _totalTags -= 1;

        emit Revoke(user, false);
    }

    // Function to transfer a tag from one address to another, only allowed if transferable is true
    function transfer(address to) public {
        require(_transferable, "Transferring is not allowed");
        require(_tags[msg.sender], "Caller is not tagged");
        require(!_tags[to], "Recipient is already tagged");

        _tags[msg.sender] = false;
        _tags[to] = true;

        emit Transfer(msg.sender, to, true);
    }
}
