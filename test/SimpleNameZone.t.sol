// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { SimpleNameZone, DmapLike } from "src/SimpleNameZone.sol";

contract SimpleNameZoneTest is Test {
    SimpleNameZone zone;
    DmapLike dmap = DmapLike(address(uint160(0x90949c9937A11BA943C7A72C3FA073a37E3FdD96))); 

    function setUp() public {
        zone = new SimpleNameZone(dmap);
    }

    function testStow(bytes32 name, bytes32 meta, bytes32 data) public {
        zone.stow(name, meta, data);
        bytes32 slot = keccak256(abi.encode(address(zone), name));
        (bool ok, bytes memory get) = address(dmap).call(abi.encodeWithSignature("get(bytes32)", slot));
        (bytes32 meta_, bytes32 data_) = abi.decode(get, (bytes32, bytes32));
        assertEq(meta, meta_);
        assertEq(data, data_);
    }

    function testGive(address heir) public {
        zone.give(heir);
        assertEq(zone.auth(), heir);
    }

    function testStowErrAuth(address owner, address not_owner) public {
        // stub
    }

    function testGiveErrAuth(address owner, address not_owner) public {
        // stub
    }
}
