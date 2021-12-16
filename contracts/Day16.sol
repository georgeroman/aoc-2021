// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day16 {
    function p1(bytes memory data) public pure returns (uint256) {
        (, uint256 versionSum) = readPacket1(data, 0);
        return versionSum;
    }

    function p2(bytes memory data) public pure returns (uint256) {
        (, uint256 result) = readPacket2(data, 0);
        return result;
    }

    function readPacket1(bytes memory data, uint256 start)
        internal
        pure
        returns (uint256, uint256)
    {
        uint256 versionSum;

        versionSum += fromBinary(data, start, start + 3);
        uint256 typeId = fromBinary(data, start + 3, start + 6);
        if (typeId == 4) {
            uint256 current = start + 6;
            bool stop;
            while (!stop) {
                stop = data[current] == "0";
                fromBinary(data, current + 1, current + 5);
                current += 5;
            }
            return (current, versionSum);
        } else {
            if (data[start + 6] == "0") {
                uint256 length = fromBinary(data, start + 7, start + 22);
                uint256 end = start + 22;
                while (end - (start + 22) < length) {
                    uint256 sum;
                    (end, sum) = readPacket1(data, end);
                    versionSum += sum;
                }
                return (end, versionSum);
            } else {
                uint256 count = fromBinary(data, start + 7, start + 18);
                uint256 end = start + 18;
                while (count >= 1) {
                    uint256 sum;
                    (end, sum) = readPacket1(data, end);
                    versionSum += sum;
                    count--;
                }
                return (end, versionSum);
            }
        }
    }

    function readPacket2(bytes memory data, uint256 start)
        internal
        pure
        returns (uint256, uint256)
    {
        uint256 typeId = fromBinary(data, start + 3, start + 6);
        if (typeId == 4) {
            uint256 number;
            uint256 current = start + 6;
            bool stop;
            while (!stop) {
                stop = data[current] == "0";
                number =
                    (number << 4) +
                    fromBinary(data, current + 1, current + 5);
                current += 5;
            }
            return (current, number);
        } else {
            uint256[] memory results = new uint256[](100);
            uint256 resultsLen;

            uint256 end;
            if (data[start + 6] == "0") {
                uint256 length = fromBinary(data, start + 7, start + 22);
                end = start + 22;
                while (end - (start + 22) < length) {
                    (end, results[resultsLen++]) = readPacket2(data, end);
                }
            } else {
                uint256 count = fromBinary(data, start + 7, start + 18);
                end = start + 18;
                while (count >= 1) {
                    (end, results[resultsLen++]) = readPacket2(data, end);
                    count--;
                }
            }

            if (typeId == 7) {
                return (end, results[0] == results[1] ? 1 : 0);
            } else if (typeId == 6) {
                return (end, results[0] < results[1] ? 1 : 0);
            } else if (typeId == 5) {
                return (end, results[0] > results[1] ? 1 : 0);
            } else if (typeId == 3) {
                uint256 max;
                for (uint256 i = 0; i < resultsLen; i++) {
                    if (results[i] > max) {
                        max = results[i];
                    }
                }
                return (end, max);
            } else if (typeId == 2) {
                uint256 min = type(uint256).max;
                for (uint256 i = 0; i < resultsLen; i++) {
                    if (results[i] < min) {
                        min = results[i];
                    }
                }
                return (end, min);
            } else if (typeId == 1) {
                uint256 prod = 1;
                for (uint256 i = 0; i < resultsLen; i++) {
                    prod *= results[i];
                }
                return (end, prod);
            } else {
                uint256 sum;
                for (uint256 i = 0; i < resultsLen; i++) {
                    sum += results[i];
                }
                return (end, sum);
            }
        }
    }

    function fromBinary(
        bytes memory data,
        uint256 start,
        uint256 end
    ) internal pure returns (uint256 result) {
        for (uint256 i = start; i < end; i++) {
            result = (result << 1) + (data[i] == "1" ? 1 : 0);
        }
    }
}
