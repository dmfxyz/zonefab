/// SPDX-License-Identifier: AGPL-3.0
/// Original credit https://github.com/packzone/packzone
pragma solidity 0.8.13;

interface DmapLike {
    function set(bytes32 name, bytes32 meta, bytes32 data) external;
}

contract SimpleNameZone {
    DmapLike immutable public dmap;
    address public auth;

    event Give(address indexed giver, address indexed heir);

    error ErrAuth();

    constructor(DmapLike _dmap_) {
        dmap = _dmap_;
        auth = tx.origin;
    }

    function stow(bytes32 name, bytes32 meta, bytes32 data) external {
        if (msg.sender != auth) revert ErrAuth();
        dmap.set(name, meta, data);
    }

    function give(address heir) external {
        if (msg.sender != auth) revert ErrAuth();
        auth = heir;
        emit Give(msg.sender, heir);
    }
}

contract SimpleNameZoneFactory {
    DmapLike immutable public dmap;
    mapping(address=>bool) public made;

    event Make(address indexed caller, address indexed zone);

    constructor(DmapLike _dmap_) {
        dmap = _dmap_;
    }

    function make() payable external returns (SimpleNameZone stub)
    {
        SimpleNameZone zone = new SimpleNameZone(dmap);
        made[address(zone)] = true;
        emit Make(msg.sender, address(zone));
        return stub;
    }
}