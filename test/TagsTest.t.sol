// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Tags.sol";

contract TagsTest is Test {
    Tags private tags;
    address private creator;
    address private user1;
    address private user2;

    function setUp() public {
        creator = address(this); // Test contract is the creator
        user1 = address(0x1);
        user2 = address(0x2);

        tags = new Tags("MyTags", "TAGS", true, true); // Revokable and transferable
    }

    function testInitialValues() public {
        assertEq(tags.name(), "MyTags");
        assertEq(tags.symbol(), "TAGS");
        assertEq(tags.totalTags(), 0);
        assertTrue(tags.revokable(), "Revokable should be true");
        assertTrue(tags.transferable(), "Transferable should be true");
    }

    function testTagUser() public {
        tags.tag(user1);
        assertEq(tags.isTagged(user1), true);
        assertEq(tags.totalTags(), 1);
    }

    function testRevokeTag() public {
        tags.tag(user1);
        tags.revoke(user1);
        assertEq(tags.isTagged(user1), false);
        assertEq(tags.totalTags(), 0);
    }

    function testCannotRevokeIfNotRevokable() public {
        Tags nonRevokableTags = new Tags("NonRevokableTags", "NRTAGS", false, true);
        nonRevokableTags.tag(user1);
        vm.expectRevert("Revoking is not allowed");
        nonRevokableTags.revoke(user1);
    }

    function testTransferTag() public {
        tags.tag(user1);

        vm.prank(user1); // Set the msg.sender to user1
        tags.transfer(user2);

        assertEq(tags.isTagged(user1), false);
        assertEq(tags.isTagged(user2), true);
    }

    function testCannotTransferIfNotTransferable() public {
        Tags nonTransferableTags = new Tags("NonTransferableTags", "NTTAGS", true, false);
        nonTransferableTags.tag(user1);

        vm.prank(user1); // Set the msg.sender to user1
        vm.expectRevert("Transferring is not allowed");
        nonTransferableTags.transfer(user2);
    }

    function testOnlyCreatorCanTag() public {
        vm.prank(user1); // Set the msg.sender to user1
        vm.expectRevert("Only the contract creator can tag");
        tags.tag(user2);
    }

    function testOnlyCreatorCanRevoke() public {
        tags.tag(user1);

        vm.prank(user2); // Set the msg.sender to user2
        vm.expectRevert("Only the contract creator can revoke");
        tags.revoke(user1);
    }
}
