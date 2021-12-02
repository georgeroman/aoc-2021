// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract Day2 {
    enum Direction {
        FORWARD,
        DOWN,
        UP
    }

    struct Instruction {
        Direction direction;
        uint256 units;
    }

    function p1(Instruction[] memory instructions)
        public
        pure
        returns (uint256 result)
    {
        uint256 x;
        uint256 y;

        for (uint256 i = 0; i < instructions.length; i++) {
            if (instructions[i].direction == Direction.FORWARD) {
                x += instructions[i].units;
            } else if (instructions[i].direction == Direction.DOWN) {
                y += instructions[i].units;
            } else if (instructions[i].direction == Direction.UP) {
                y -= instructions[i].units;
            }
        }

        result = x * y;
    }

    function p2(Instruction[] memory instructions)
        public
        pure
        returns (uint256 result)
    {
        uint256 aim;
        uint256 x;
        uint256 y;

        for (uint256 i = 0; i < instructions.length; i++) {
            if (instructions[i].direction == Direction.FORWARD) {
                x += instructions[i].units;
                y += aim * instructions[i].units;
            } else if (instructions[i].direction == Direction.DOWN) {
                aim += instructions[i].units;
            } else if (instructions[i].direction == Direction.UP) {
                aim -= instructions[i].units;
            }
        }

        result = x * y;
    }
}
