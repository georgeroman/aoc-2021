// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day10 {
    function p1(string[] memory lines) public pure returns (uint256 result) {
        for (uint256 i = 0; i < lines.length; i++) {
            bytes1[] memory stack = new bytes1[](bytes(lines[i]).length);
            uint256 position;

            for (uint256 k = 0; k < bytes(lines[i]).length; k++) {
                bytes1 c = bytes(lines[i])[k];
                if (c == "(" || c == "[" || c == "{" || c == "<") {
                    stack[position++] = c;
                } else {
                    bytes1 s = stack[--position];
                    if (c == ")" && s != "(") {
                        result += 3;
                        break;
                    } else if (c == "]" && s != "[") {
                        result += 57;
                        break;
                    } else if (c == "}" && s != "{") {
                        result += 1197;
                        break;
                    } else if (c == ">" && s != "<") {
                        result += 25137;
                        break;
                    }
                }
            }
        }
    }

    function p2(string[] memory lines) public pure returns (uint256 result) {
        uint256[] memory scores = new uint256[](lines.length);
        uint256 scoresLen;

        for (uint256 i = 0; i < lines.length; i++) {
            bytes1[] memory stack = new bytes1[](bytes(lines[i]).length);
            uint256 stackLen;

            bool isCorrupted = false;
            for (uint256 k = 0; k < bytes(lines[i]).length; k++) {
                bytes1 c = bytes(lines[i])[k];
                if (c == "(" || c == "[" || c == "{" || c == "<") {
                    stack[stackLen++] = c;
                } else {
                    bytes1 s = stack[--stackLen];
                    if (c == ")" && s != "(") {
                        isCorrupted = true;
                        break;
                    } else if (c == "]" && s != "[") {
                        isCorrupted = true;
                        break;
                    } else if (c == "}" && s != "{") {
                        isCorrupted = true;
                        break;
                    } else if (c == ">" && s != "<") {
                        isCorrupted = true;
                        break;
                    }
                }
            }

            if (isCorrupted) {
                continue;
            }

            uint256 score;
            while (stackLen > 0) {
                bytes1 s = stack[--stackLen];
                if (s == "(") {
                    score = score * 5 + 1;
                } else if (s == "[") {
                    score = score * 5 + 2;
                } else if (s == "{") {
                    score = score * 5 + 3;
                } else if (s == "<") {
                    score = score * 5 + 4;
                }
            }

            scores[scoresLen++] = score;
        }

        quickSort(scores, 0, int256(scoresLen) - 1);
        result = scores[scoresLen / 2];
    }

    // Taken from https://ethereum.stackexchange.com/a/1518
    function quickSort(
        uint256[] memory array,
        int256 left,
        int256 right
    ) internal pure {
        int256 i = left;
        int256 j = right;
        if (i == j) {
            return;
        }

        uint256 pivot = array[uint256(left + (right - left) / 2)];
        while (i <= j) {
            while (array[uint256(i)] < pivot) {
                i++;
            }
            while (pivot < array[uint256(j)]) {
                j--;
            }
            if (i <= j) {
                (array[uint256(i)], array[uint256(j)]) = (
                    array[uint256(j)],
                    array[uint256(i)]
                );
                i++;
                j--;
            }
        }
        if (left < j) {
            quickSort(array, left, j);
        }
        if (i < right) {
            quickSort(array, i, right);
        }
    }
}
