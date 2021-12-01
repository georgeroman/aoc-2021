// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day1 {
    function p1(uint256[] memory measurements)
        public
        pure
        returns (uint256 increaseCount)
    {
        for (uint256 i = 1; i < measurements.length; i++) {
            if (measurements[i] > measurements[i - 1]) {
                increaseCount++;
            }
        }
    }

    function p2(uint256[] memory measurements)
        public
        pure
        returns (uint256 increaseCount)
    {
        uint256[] memory slidingWindows = new uint256[](
            measurements.length - 2
        );

        for (uint256 i = 0; i < measurements.length - 2; i++) {
            slidingWindows[i] =
                measurements[i] +
                measurements[i + 1] +
                measurements[i + 2];
        }

        increaseCount = p1(slidingWindows);
    }
}
