// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day9 {
    function p1(uint256[][] memory heights)
        public
        pure
        returns (uint256 result)
    {
        for (uint256 i = 0; i < heights.length; i++) {
            for (uint256 j = 0; j < heights[i].length; j++) {
                uint256 current = heights[i][j];

                bool isLowPoint = true;
                if (i > 0) {
                    isLowPoint = isLowPoint && (current < heights[i - 1][j]);
                }
                if (i < heights.length - 1) {
                    isLowPoint = isLowPoint && (current < heights[i + 1][j]);
                }
                if (j > 0) {
                    isLowPoint = isLowPoint && (current < heights[i][j - 1]);
                }
                if (j < heights[i].length - 1) {
                    isLowPoint = isLowPoint && (current < heights[i][j + 1]);
                }

                if (isLowPoint) {
                    result += current + 1;
                }
            }
        }
    }

    function p2(uint256[][] memory heights) public returns (uint256 result) {
        uint256 largest1;
        uint256 largest2;
        uint256 largest3;

        uint256 id = 0;
        for (uint256 i = 0; i < heights.length; i++) {
            for (uint256 j = 0; j < heights[i].length; j++) {
                uint256 current = heights[i][j];

                bool isLowPoint = true;
                if (i > 0) {
                    isLowPoint = isLowPoint && (current < heights[i - 1][j]);
                }
                if (i < heights.length - 1) {
                    isLowPoint = isLowPoint && (current < heights[i + 1][j]);
                }
                if (j > 0) {
                    isLowPoint = isLowPoint && (current < heights[i][j - 1]);
                }
                if (j < heights[i].length - 1) {
                    isLowPoint = isLowPoint && (current < heights[i][j + 1]);
                }

                if (isLowPoint) {
                    uint256 basin = findBasinSize(heights, id++, i, j);
                    if (basin >= largest1) {
                        (largest2, largest3) = (largest1, largest2);
                        largest1 = basin;
                    } else if (basin >= largest2) {
                        largest3 = largest2;
                        largest2 = basin;
                    } else if (basin >= largest3) {
                        largest3 = basin;
                    }
                }
            }
        }

        result = largest1 * largest2 * largest3;
    }

    mapping(uint256 => mapping(uint256 => mapping(uint256 => bool)))
        internal met;

    function findBasinSize(
        uint256[][] memory heights,
        uint256 id,
        uint256 i,
        uint256 j
    ) internal returns (uint256 result) {
        if (met[id][i][j] || heights[i][j] == 9) {
            result = 0;
        } else {
            met[id][i][j] = true;
            result = 1;
            if (i > 0 && heights[i][j] < heights[i - 1][j]) {
                result += findBasinSize(heights, id, i - 1, j);
            }
            if (i < heights.length - 1 && heights[i][j] < heights[i + 1][j]) {
                result += findBasinSize(heights, id, i + 1, j);
            }
            if (j > 0 && heights[i][j] < heights[i][j - 1]) {
                result += findBasinSize(heights, id, i, j - 1);
            }
            if (
                j < heights[i].length - 1 && heights[i][j] < heights[i][j + 1]
            ) {
                result += findBasinSize(heights, id, i, j + 1);
            }
        }
    }
}
