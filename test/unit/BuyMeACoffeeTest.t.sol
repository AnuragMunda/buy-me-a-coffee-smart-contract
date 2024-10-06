// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {BuyMeACoffee} from "../../src/BuyMeACoffee.sol";
import {DeployBuyMeACoffee} from "../../script/DeployBuyMeACoffee.s.sol";

contract BuyMeACoffeeTest is Test {
    BuyMeACoffee public buyMeACoffee;
    DeployBuyMeACoffee deployer;

    address public DONOR = makeAddr("donor");
    address public OWNER = 0x438afB9Fb11C67F1AaA6A02A92223D3bE7Fc1a0D;

    function setUp() external {
        deployer = new DeployBuyMeACoffee();
        buyMeACoffee = deployer.run();
        console.log(address(deployer), buyMeACoffee.s_owner(), address(this));
        vm.deal(DONOR, 10 ether);
    }

    function test_DonorCanBuyMeACoffee() external {
        vm.prank(DONOR);
        buyMeACoffee.buyCoffee{value: 1 ether}("Anurag", "Have a great day!");
        BuyMeACoffee.Memo[] memory memos = buyMeACoffee.getMemos();
        assertEq(memos[0].name, "Anurag");
        assertEq(memos[0].message, "Have a great day!");
    }

    function test_OwnerCanWithdrawBalance() external {
        vm.prank(DONOR);
        buyMeACoffee.buyCoffee{value: 1 ether}("Anurag", "Have a great day!");
        vm.prank(OWNER);
        buyMeACoffee.withdrawTips();
        assertEq(address(buyMeACoffee).balance, 0);
        assertEq(OWNER.balance, 1 ether);
    }
}
