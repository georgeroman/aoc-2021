// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";

contract Day4 {
    using SafeCast for int256;

    function p1(
        uint256[] memory numbers,
        uint256[][][] memory boards,
        uint256 boardSize
    ) public pure returns (uint256) {
        uint256[] memory elems = new uint256[](
            boards.length * boardSize**2 * 2
        );

        for (uint256 i = 0; i < boards.length; i++) {
            uint256 offset = i * boardSize**2 * 2;
            for (uint256 r = 0; r < boardSize; r++) {
                for (uint256 c = 0; c < boardSize; c++) {
                    uint256 index = offset + r * boardSize + c;
                    elems[index] = boards[i][r][c];
                }
            }

            for (uint256 c = 0; c < boardSize; c++) {
                for (uint256 r = 0; r < boardSize; r++) {
                    uint256 index = offset + boardSize**2 + c * boardSize + r;
                    elems[index] = boards[i][r][c];
                }
            }
        }

        for (uint256 k = 0; k < numbers.length; k++) {
            for (uint256 l = 0; l < elems.length; l++) {
                if (elems[l] == numbers[k]) {
                    elems[l] = type(uint256).max;
                }
            }

            for (uint256 m = 0; m < elems.length; m += boardSize) {
                bool bingo = true;
                for (uint256 n = 0; n < boardSize; n++) {
                    if (elems[m + n] != type(uint256).max) {
                        bingo = false;
                        break;
                    }
                }

                if (bingo) {
                    uint256 nonMarkedSum;
                    uint256 boardStartIndex = (m / (boardSize**2 * 2)) *
                        boardSize**2 *
                        2;
                    for (uint256 n = 0; n < boardSize**2; n++) {
                        if (elems[boardStartIndex + n] != type(uint256).max) {
                            nonMarkedSum += elems[boardStartIndex + n];
                        }
                    }
                    return nonMarkedSum * numbers[k];
                }
            }
        }

        return 0;
    }

    mapping(uint256 => bool) internal winningBoards;

    function p2(
        uint256[] memory numbers,
        uint256[][][] memory boards,
        uint256 boardSize
    ) public returns (uint256) {
        uint256[] memory elems = new uint256[](
            boards.length * boardSize**2 * 2
        );

        for (uint256 i = 0; i < boards.length; i++) {
            uint256 offset = i * boardSize**2 * 2;
            for (uint256 r = 0; r < boardSize; r++) {
                for (uint256 c = 0; c < boardSize; c++) {
                    uint256 index = offset + r * boardSize + c;
                    elems[index] = boards[i][r][c];
                }
            }

            for (uint256 c = 0; c < boardSize; c++) {
                for (uint256 r = 0; r < boardSize; r++) {
                    uint256 index = offset + boardSize**2 + c * boardSize + r;
                    elems[index] = boards[i][r][c];
                }
            }
        }

        uint256 numWinningBoards;
        for (uint256 k = 0; k < numbers.length; k++) {
            for (uint256 l = 0; l < elems.length; l++) {
                if (elems[l] == numbers[k]) {
                    elems[l] = type(uint256).max;
                }
            }

            uint256 m;
            while (m < elems.length) {
                uint256 boardIndex = m / (boardSize**2 * 2);
                if (winningBoards[boardIndex]) {
                    m = (boardIndex + 1) * boardSize**2 * 2;
                    continue;
                }

                bool bingo = true;
                for (uint256 n = 0; n < boardSize; n++) {
                    if (elems[m + n] != type(uint256).max) {
                        bingo = false;
                        break;
                    }
                }

                if (bingo) {
                    if (numWinningBoards == boards.length - 1) {
                        uint256 nonMarkedSum;
                        uint256 boardStartIndex = boardIndex * boardSize**2 * 2;
                        for (uint256 n = 0; n < boardSize**2; n++) {
                            if (
                                elems[boardStartIndex + n] != type(uint256).max
                            ) {
                                nonMarkedSum += elems[boardStartIndex + n];
                            }
                        }
                        return nonMarkedSum * numbers[k];
                    } else {
                        winningBoards[boardIndex] = true;
                        numWinningBoards++;
                    }
                }

                m += boardSize;
            }
        }

        return 0;
    }
}
