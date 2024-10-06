// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Script} from "forge-std/Script.sol";
import {BuyMeACoffee} from "../../src/BuyMeACoffee.sol";

contract DeployBuyMeACoffee is Script {
    function run() external returns (BuyMeACoffee) {
        vm.startBroadcast(0x438afB9Fb11C67F1AaA6A02A92223D3bE7Fc1a0D);
        BuyMeACoffee buyMeACoffee = new BuyMeACoffee();
        vm.stopBroadcast();

        return buyMeACoffee;
    }
}
