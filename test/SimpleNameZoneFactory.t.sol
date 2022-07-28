// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { SimpleNameZoneFactory, SimpleNameZone, Dmap } from "src/SimpleNameZone.sol";

contract FactoryTest is Test {
    SimpleNameZoneFactory fab;
    Dmap dmap = Dmap(address(uint160(0x90949c9937A11BA943C7A72C3FA073a37E3FdD96)));
    event Give(address indexed giver, address indexed heir);


    function setUp() public {
        fab = new SimpleNameZoneFactory(dmap);
    }

    function testSimpleFab() public {
        vm.expectEmit(true, true, false, false);
        emit Give(address(fab), address(this));
        SimpleNameZone zone = fab.make();
        assertEq(zone.auth(), address(this));
    }
}