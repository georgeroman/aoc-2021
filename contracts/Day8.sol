// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract Day8 {
    function p1(string[][] memory right) public pure returns (uint256 result) {
        for (uint256 i = 0; i < right.length; i++) {
            for (uint256 j = 0; j < right[i].length; j++) {
                uint256 l = bytes(right[i][j]).length;
                if (l == 2 || l == 3 || l == 4 || l == 7) {
                    result++;
                }
            }
        }
    }

    mapping(bytes1 => uint8) internal letterToPosition;

    function p2(string[][] memory left, string[][] memory right)
        public
        returns (uint256 result)
    {
        for (uint256 i = 0; i < left.length; i++) {
            bytes[] memory counts = new bytes[](10);
            for (bytes1 b = "a"; b <= "g"; b = bytes1(uint8(b) + 1)) {
                letterToPosition[b] = type(uint8).max;
            }

            for (uint256 k = 0; k < left[i].length; k++) {
                bytes memory current = bytes(left[i][k]);

                if (current.length == 2) {
                    counts[0] = current;
                } else if (current.length == 3) {
                    counts[1] = current;
                } else if (current.length == 4) {
                    counts[2] = current;
                } else if (current.length == 5) {
                    if (counts[3].length == 0) {
                        counts[3] = current;
                    } else if (counts[4].length == 0) {
                        counts[4] = current;
                    } else if (counts[5].length == 0) {
                        counts[5] = current;
                    }
                } else if (current.length == 6) {
                    if (counts[6].length == 0) {
                        counts[6] = current;
                    } else if (counts[7].length == 0) {
                        counts[7] = current;
                    } else if (counts[8].length == 0) {
                        counts[8] = current;
                    }
                } else if (current.length == 7) {
                    counts[9] = current;
                }
            }

            // Find position 0
            {
                bytes memory diff = setDifference(counts[1], counts[0]);
                letterToPosition[diff[0]] = 0;
            }

            bytes memory zero;
            bytes memory six;
            bytes memory nine;

            // Find positions 2, 3 and 5
            {
                bytes memory diff1 = setDifference(counts[9], counts[6]);
                if (counts[0][0] == diff1[0] || counts[0][1] == diff1[0]) {
                    letterToPosition[diff1[0]] = 2;
                    six = counts[6];

                    if (counts[0][0] == diff1[0]) {
                        letterToPosition[counts[0][1]] = 5;
                    } else if (counts[0][1] == diff1[0]) {
                        letterToPosition[counts[0][0]] = 5;
                    }

                    bytes memory diff2 = setDifference(counts[2], counts[7]);
                    if (diff2[0] != 0) {
                        letterToPosition[diff2[0]] = 3;
                        zero = counts[7];
                        nine = counts[8];
                    } else {
                        bytes memory diff3 = setDifference(
                            counts[2],
                            counts[8]
                        );
                        letterToPosition[diff3[0]] = 3;
                        zero = counts[8];
                        nine = counts[7];
                    }
                } else {
                    bytes memory diff2 = setDifference(counts[9], counts[7]);
                    if (counts[0][0] == diff2[0] || counts[0][1] == diff2[0]) {
                        letterToPosition[diff2[0]] = 2;
                        six = counts[7];

                        if (counts[0][0] == diff2[0]) {
                            letterToPosition[counts[0][1]] = 5;
                        } else if (counts[0][1] == diff2[0]) {
                            letterToPosition[counts[0][0]] = 5;
                        }

                        bytes memory diff4 = setDifference(
                            counts[2],
                            counts[6]
                        );
                        if (diff4[0] != 0) {
                            letterToPosition[diff4[0]] = 3;
                            zero = counts[6];
                            nine = counts[8];
                        } else {
                            bytes memory diff5 = setDifference(
                                counts[2],
                                counts[8]
                            );
                            letterToPosition[diff5[0]] = 3;
                            zero = counts[8];
                            nine = counts[6];
                        }
                    } else {
                        bytes memory diff3 = setDifference(
                            counts[9],
                            counts[8]
                        );
                        if (
                            counts[0][0] == diff3[0] || counts[0][1] == diff3[0]
                        ) {
                            letterToPosition[diff3[0]] = 2;
                            six = counts[8];

                            if (counts[0][0] == diff3[0]) {
                                letterToPosition[counts[0][1]] = 5;
                            } else if (counts[0][1] == diff3[0]) {
                                letterToPosition[counts[0][0]] = 5;
                            }

                            bytes memory diff4 = setDifference(
                                counts[2],
                                counts[6]
                            );
                            if (diff4[0] != 0) {
                                letterToPosition[diff4[0]] = 3;
                                zero = counts[6];
                                nine = counts[7];
                            } else {
                                bytes memory diff5 = setDifference(
                                    counts[2],
                                    counts[7]
                                );
                                letterToPosition[diff5[0]] = 3;
                                zero = counts[7];
                                nine = counts[6];
                            }
                        }
                    }
                }
            }

            // Find position 4
            {
                bytes memory diff = setDifference(counts[9], nine);
                letterToPosition[diff[0]] = 4;
            }

            // Find positions 1 and 6
            {
                bytes memory current = new bytes(5);
                uint256 count;
                for (bytes1 b = "a"; b <= "g"; b = bytes1(uint8(b) + 1)) {
                    if (letterToPosition[b] != 255) {
                        current[count++] = b;
                    }
                }

                bytes memory diff1 = setDifference(counts[2], current);
                letterToPosition[diff1[0]] = 1;

                for (bytes1 b = "a"; b <= "g"; b = bytes1(uint8(b) + 1)) {
                    if (letterToPosition[b] == 255) {
                        letterToPosition[b] = 6;
                        break;
                    }
                }
            }

            uint256 number;
            for (int256 k = int256(right[i].length) - 1; k >= 0; k--) {
                uint8 digit = getDigit(bytes(right[i][uint256(k)]));
                number += digit * 10**(right[i].length - 1 - uint256(k));
            }

            result += number;
        }
    }

    function getDigit(bytes memory code) internal view returns (uint8 result) {
        if (code.length == 2) {
            result = 1;
        } else if (code.length == 3) {
            result = 7;
        } else if (code.length == 4) {
            result = 4;
        } else if (code.length == 5) {
            result = 3;
            for (uint256 i = 0; i < code.length; i++) {
                if (letterToPosition[code[i]] == 1) {
                    result = 5;
                    break;
                } else if (letterToPosition[code[i]] == 4) {
                    result = 2;
                    break;
                }
            }
        } else if (code.length == 6) {
            result = 0;
            bool isZero = true;
            for (uint256 i = 0; i < code.length; i++) {
                if (letterToPosition[code[i]] == 3) {
                    isZero = false;
                    break;
                }
            }

            if (!isZero) {
                for (uint256 i = 0; i < code.length; i++) {
                    if (letterToPosition[code[i]] == 4) {
                        result = 6;
                        break;
                    } else if (letterToPosition[code[i]] == 2) {
                        result = 9;
                        break;
                    }
                }
            }
        } else if (code.length == 7) {
            result = 8;
        }
    }

    function setDifference(bytes memory left, bytes memory right)
        internal
        pure
        returns (bytes memory result)
    {
        result = new bytes(left.length);
        uint256 count;
        for (uint256 i = 0; i < left.length; i++) {
            bool found = false;
            for (uint256 j = 0; j < right.length; j++) {
                if (left[i] == right[j]) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                result[count++] = left[i];
            }
        }
    }
}
