// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/math/Math.sol";

contract Day5 {
    struct Point {
        uint256 x;
        uint256 y;
    }

    struct Line {
        Point start;
        Point end;
    }

    mapping(uint256 => mapping(uint256 => bool)) internal pointCounted;
    mapping(uint256 => mapping(uint256 => uint256)) internal points;

    function p1(Line[] memory lines) public returns (uint256 result) {
        for (uint256 i = 0; i < lines.length; i++) {
            if (
                lines[i].start.x == lines[i].end.x ||
                lines[i].start.y == lines[i].end.y
            ) {
                uint256 minX = Math.min(lines[i].start.x, lines[i].end.x);
                uint256 maxX = Math.max(lines[i].start.x, lines[i].end.x);
                uint256 minY = Math.min(lines[i].start.y, lines[i].end.y);
                uint256 maxY = Math.max(lines[i].start.y, lines[i].end.y);

                for (uint256 x = minX; x <= maxX; x++) {
                    for (uint256 y = minY; y <= maxY; y++) {
                        points[x][y]++;
                        if (!pointCounted[x][y] && points[x][y] > 1) {
                            pointCounted[x][y] = true;
                            result++;
                        }
                    }
                }
            }
        }
    }

    function p2(Line[] memory lines) public returns (uint256 result) {
        for (uint256 i = 0; i < lines.length; i++) {
            int256 xDiff;
            if (lines[i].start.x < lines[i].end.x) {
                xDiff = 1;
            } else if (lines[i].start.x > lines[i].end.x) {
                xDiff = -1;
            }

            int256 yDiff;
            if (lines[i].start.y < lines[i].end.y) {
                yDiff = 1;
            } else if (lines[i].start.y > lines[i].end.y) {
                yDiff = -1;
            }

            uint256 cx = lines[i].start.x;
            uint256 cy = lines[i].start.y;
            while (true) {
                points[cx][cy]++;
                if (!pointCounted[cx][cy] && points[cx][cy] > 1) {
                    pointCounted[cx][cy] = true;
                    result++;
                }

                if (cx == lines[i].end.x && cy == lines[i].end.y) {
                    break;
                } else {
                    cx = uint256(int256(cx) + xDiff);
                    cy = uint256(int256(cy) + yDiff);
                }
            }
        }
    }
}
