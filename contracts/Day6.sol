// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day6 {
    function p1(int256[] memory states, int256 numDays)
        public
        returns (int256 result)
    {
        for (uint256 i = 0; i < states.length; i++) {
            result += 1 + getNumCreatedFish(numDays - states[i]);
        }
    }

    mapping(int256 => int256) internal cache;

    function getNumCreatedFish(int256 numDays)
        internal
        returns (int256 result)
    {
        if (cache[numDays] != 0) {
            result = cache[numDays];
        } else if (numDays >= 0) {
            result += (numDays + 7 - 1) / 7;
            for (int256 i = 0; i <= numDays / 7; i++) {
                result += getNumCreatedFish(numDays - i * 7 - 9);
            }
            cache[numDays] = result;
        }
    }
}
