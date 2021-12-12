// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day12 {
    struct Path {
        bytes32 from;
        bytes32 to;
    }

    function p1(Path[] memory _paths) public returns (uint256 result) {
        for (uint256 i = 0; i < _paths.length; i++) {
            paths[_paths[i].from].push(_paths[i].to);
            paths[_paths[i].to].push(_paths[i].from);
        }

        result = numPaths1(bytes32("start"));
    }

    function p2(Path[] memory _paths) public returns (uint256 result) {
        for (uint256 i = 0; i < _paths.length; i++) {
            paths[_paths[i].from].push(_paths[i].to);
            paths[_paths[i].to].push(_paths[i].from);
        }

        result = numPaths2(bytes32("start"), true);
    }

    mapping(bytes32 => bytes32[]) internal paths;
    mapping(bytes32 => bool) visited;

    function numPaths1(bytes32 from) internal returns (uint256 result) {
        if (from == bytes32("end")) {
            return 1;
        }

        if (visited[from]) {
            return 0;
        }

        if (from[0] >= 0x61) {
            visited[from] = true;
        }
        for (uint256 i = 0; i < paths[from].length; i++) {
            result += numPaths1(paths[from][i]);
        }
        visited[from] = false;
    }

    function numPaths2(bytes32 from, bool allowedTwice)
        internal
        returns (uint256 result)
    {
        if (from == bytes32("end")) {
            return 1;
        }

        bool unvisit = true;
        if (visited[from]) {
            if (allowedTwice) {
                allowedTwice = false;
                unvisit = false;
            } else {
                return 0;
            }
        }

        if (from[0] >= 0x61) {
            visited[from] = true;
        }
        for (uint256 i = 0; i < paths[from].length; i++) {
            if (paths[from][i] != bytes32("start")) {
                result += numPaths2(paths[from][i], allowedTwice);
            }
        }
        if (unvisit) {
            visited[from] = false;
        }
    }
}
