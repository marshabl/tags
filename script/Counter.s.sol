// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/Tags.sol";

contract DeployTags is Script {
    function run() external {
        vm.startBroadcast();

        Tags tags = new Tags("MyTags", "TAGS", true, true);
        console.log("Tags contract deployed at:", address(tags));

        vm.stopBroadcast();
    }
}
