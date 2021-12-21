// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day21 {
    function p1(uint256 p1Start, uint256 p2Start)
        public
        view
        returns (uint256 result)
    {
        uint256 p1Pos = p1Start;
        uint256 p1Score;
        uint256 p2Pos = p2Start;
        uint256 p2Score;

        uint256 dice;
        uint256 rolls;
        while (true) {
            uint256 dice1 = ((dice + 1 - 1) % 100) + 1;
            uint256 dice2 = ((dice + 2 - 1) % 100) + 1;
            uint256 dice3 = ((dice + 3 - 1) % 100) + 1;

            dice = dice3;
            rolls += 3;

            p1Pos = ((p1Pos + dice1 + dice2 + dice3 - 1) % 10) + 1;
            p1Score += p1Pos;
            if (p1Score >= 1000) {
                return rolls * p2Score;
            }

            dice1 = ((dice + 1 - 1) % 100) + 1;
            dice2 = ((dice + 2 - 1) % 100) + 1;
            dice3 = ((dice + 3 - 1) % 100) + 1;

            dice = dice3;
            rolls += 3;

            p2Pos = ((p2Pos + dice1 + dice2 + dice3 - 1) % 10) + 1;
            p2Score += p2Pos;
            if (p2Score >= 1000) {
                return rolls * p1Score;
            }
        }
    }

    struct Input {
        uint256 pos;
        uint256 score;
        uint256 dice1;
        uint256 dice2;
        uint256 dice3;
    }
    struct Result {
        bool isValid;
        uint256 p1Wins;
        uint256 p2Wins;
    }

    function p2(uint256 p1Start, uint256 p2Start)
        public
        returns (uint256 result)
    {
        Result memory r = countWins(p1Start, 0, p2Start, 0);
        return r.p1Wins > r.p2Wins ? r.p1Wins : r.p2Wins;
    }

    mapping(bytes32 => Result) internal cache;

    function countWins(
        uint256 p1Pos,
        uint256 p1Score,
        uint256 p2Pos,
        uint256 p2Score
    ) public returns (Result memory result) {
        if (p2Score >= 21) {
            return Result(true, 0, 1);
        }

        bytes32 id = keccak256(
            abi.encodePacked(p1Pos, p1Score, p2Pos, p2Score)
        );
        if (cache[id].isValid) {
            return cache[id];
        }

        result.isValid = true;

        uint256[] memory rollSum = new uint256[](7);
        uint256[] memory rollSumCount = new uint256[](7);
        rollSum[0] = 3;
        rollSumCount[0] = 1;
        rollSum[1] = 4;
        rollSumCount[1] = 3;
        rollSum[2] = 5;
        rollSumCount[2] = 6;
        rollSum[3] = 6;
        rollSumCount[3] = 7;
        rollSum[4] = 7;
        rollSumCount[4] = 6;
        rollSum[5] = 8;
        rollSumCount[5] = 3;
        rollSum[6] = 9;
        rollSumCount[6] = 1;
        for (uint256 i = 0; i < 7; i++) {
            uint256 p1PosNew = ((p1Pos + rollSum[i] - 1) % 10) + 1;
            uint256 p1ScoreNew = p1Score + p1PosNew;

            Result memory r = countWins(p2Pos, p2Score, p1PosNew, p1ScoreNew);
            result.p1Wins += r.p2Wins * rollSumCount[i];
            result.p2Wins += r.p1Wins * rollSumCount[i];
        }

        cache[id] = result;
        return cache[id];
    }
}
