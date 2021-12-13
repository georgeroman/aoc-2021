// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day13 {
    struct Point {
        uint256 x;
        uint256 y;
    }

    struct Fold {
        bytes32 kind;
        uint256 value;
    }

    function p1(
        uint256[][] memory paper,
        Point[] memory points,
        Fold[] memory folds
    ) public pure returns (uint256 result) {
        simulate(paper, points, folds, true);

        for (uint256 i = 0; i < paper.length; i++) {
            for (uint256 j = 0; j < paper[i].length; j++) {
                if (paper[i][j] == 1) {
                    result++;
                }
            }
        }
    }

    function p2(
        uint256[][] memory paper,
        Point[] memory points,
        Fold[] memory folds
    ) public pure returns (string memory result) {
        simulate(paper, points, folds, false);

        uint256 maxX;
        uint256 maxY;

        for (uint256 i = 0; i < points.length; i++) {
            if (points[i].x > maxX) {
                maxX = points[i].x;
            }
            if (points[i].y > maxY) {
                maxY = points[i].y;
            }
        }

        for (uint256 y = 0; y <= maxY; y++) {
            for (uint256 x = 0; x <= maxX; x++) {
                result = string(
                    abi.encodePacked(result, paper[y][x] == 1 ? "#" : ".")
                );
            }
            result = string(abi.encodePacked(result, "\n"));
        }
    }

    function simulate(
        uint256[][] memory paper,
        Point[] memory points,
        Fold[] memory folds,
        bool breakAtFirst
    ) internal pure {
        for (uint256 i = 0; i < folds.length; i++) {
            if (folds[i].kind == bytes32("x")) {
                for (uint256 k = 0; k < points.length; k++) {
                    if (points[k].x > folds[i].value) {
                        paper[points[k].y][points[k].x] = 0;
                        paper[points[k].y][
                            2 * folds[i].value - points[k].x
                        ] = 1;
                        points[k].x = 2 * folds[i].value - points[k].x;
                    }
                }
            } else if (folds[i].kind == bytes32("y")) {
                for (uint256 k = 0; k < points.length; k++) {
                    if (points[k].y > folds[i].value) {
                        paper[points[k].y][points[k].x] = 0;
                        paper[2 * folds[i].value - points[k].y][
                            points[k].x
                        ] = 1;
                        points[k].y = 2 * folds[i].value - points[k].y;
                    }
                }
            }

            if (breakAtFirst) {
                break;
            }
        }
    }
}
