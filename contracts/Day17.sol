// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day17 {
    function p1(int256 lowY, int256 highY) public pure returns (int256 result) {
        // Brute-force y
        for (int256 y = 1; y <= 500; y++) {
            int256 maxY;
            int256 yPos;
            int256 yVel = y;

            bool fits;
            bool stop;
            while (!stop) {
                yPos += yVel;
                yVel--;
                maxY = yPos > maxY ? yPos : maxY;
                if (lowY <= yPos && yPos <= highY) {
                    fits = true;
                }
                if (yPos < lowY) {
                    stop = true;
                }
            }

            if (fits) {
                result = maxY > result ? maxY : result;
            }
        }
    }

    mapping(int256 => mapping(int256 => bool)) internal counted;

    function p2(
        int256 lowX,
        int256 highX,
        int256 lowY,
        int256 highY
    ) public returns (uint256 result) {
        // Find x positions and steps that reach target
        int256[] memory xVels = new int256[](200);
        int256[] memory xSteps = new int256[](200);
        bool[] memory xIsZero = new bool[](200);
        uint256 xLen;
        for (int256 x = 1; x <= 200; x++) {
            int256 xPos;
            int256 xVel = x;

            bool stop;
            int256 step;
            while (!stop) {
                xPos += xVel;
                xVel = xVel > 0 ? xVel - 1 : int256(0);
                step++;
                if (lowX <= xPos && xPos <= highX) {
                    xVels[xLen] = x;
                    xSteps[xLen] = step;
                    if (xVel == 0) {
                        xIsZero[xLen] = true;
                    }
                    xLen++;
                }
                if (xVel == 0 || xPos > highX) {
                    stop = true;
                }
            }
        }

        for (uint256 i = 0; i < xLen; i++) {
            // Brute-force y
            for (int256 y = -150; y <= 250; y++) {
                if (!xIsZero[i]) {
                    int256 yPos;
                    int256 yVel = y;

                    int256 step;
                    while (step < xSteps[i]) {
                        yPos += yVel;
                        yVel--;
                        step++;
                    }

                    if (lowY <= yPos && yPos <= highY) {
                        if (!counted[xVels[i]][y]) {
                            counted[xVels[i]][y] = true;
                            result++;
                        }
                    }
                } else {
                    int256 yPos;
                    int256 yVel = y;

                    bool stop;
                    int256 step;
                    while (!stop) {
                        yPos += yVel;
                        yVel--;
                        step++;
                        if (
                            step >= xSteps[i] && lowY <= yPos && yPos <= highY
                        ) {
                            if (!counted[xVels[i]][y]) {
                                counted[xVels[i]][y] = true;
                                result++;
                            }
                        }
                        if (yPos < lowY) {
                            stop = true;
                        }
                    }
                }
            }
        }
    }
}
