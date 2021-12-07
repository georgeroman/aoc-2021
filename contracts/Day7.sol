// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/Math.sol";

contract Day7 {
    function p1(int256[] memory positions) public view returns (int256 result) {
        quickSort(positions, 0, int256(positions.length) - 1);

        // We have to solve the linear optimization of sum of moduli differences.
        // That is, sum of |p0 - x| + |p1 - x| + ... + |pn - x|. The solution to
        // this is given by taking the above expression's derivative and equating
        // it to 0. We know that d/dx |s - x| = sign(s - x), so to have the above
        // sum equal to 0 we must have all terms cancelling each other. This is
        // achieved when choosing x as being the median of p0, p1, ... pn.

        int256 median;
        if (positions.length % 2 == 1) {
            median = positions[positions.length / 2 + 1];
        } else {
            median =
                (positions[positions.length / 2 - 1] +
                    positions[positions.length / 2]) /
                2;
        }

        for (uint256 i = 0; i < positions.length; i++) {
            result += median >= positions[i]
                ? median - positions[i]
                : positions[i] - median;
        }
    }

    function p2(int256[] memory positions) public view returns (int256 result) {
        quickSort(positions, 0, int256(positions.length) - 1);

        // This time, we don't have a linear optimization problem, but a
        // quadratic one which is a bit trickier to solve directly, so here
        // we just brute-force the right and left sides of the median because
        // we know for sure that's where the optimum resides.

        int256 median;
        if (positions.length % 2 == 1) {
            median = positions[positions.length / 2 + 1];
        } else {
            median =
                (positions[positions.length / 2 - 1] +
                    positions[positions.length / 2]) /
                2;
        }

        int256 atMedian;
        for (uint256 i = 0; i < positions.length; i++) {
            atMedian += median >= positions[i]
                ? ((median - positions[i]) * (median - positions[i] + 1)) / 2
                : ((positions[i] - median) * (positions[i] - median + 1)) / 2;
        }

        int256 rightBest = atMedian;
        for (
            int256 mr = median + 1;
            mr <= positions[positions.length - 1];
            mr++
        ) {
            int256 currentRight;
            for (uint256 kr = 0; kr < positions.length; kr++) {
                currentRight += mr >= positions[kr]
                    ? ((mr - positions[kr]) * (mr - positions[kr] + 1)) / 2
                    : ((positions[kr] - mr) * (positions[kr] - mr + 1)) / 2;
            }

            if (currentRight <= rightBest) {
                rightBest = currentRight;
            } else {
                break;
            }
        }

        int256 leftBest = atMedian;
        for (int256 ml = median - 1; ml >= positions[0]; ml--) {
            int256 currentLeft;
            for (uint256 kl = 0; kl < positions.length; kl++) {
                currentLeft += ml >= positions[kl]
                    ? ((ml - positions[kl]) * (ml - positions[kl] + 1)) / 2
                    : ((positions[kl] - ml) * (positions[kl] - ml + 1)) / 2;
            }

            if (currentLeft <= leftBest) {
                leftBest = currentLeft;
            } else {
                break;
            }
        }

        result = int256(Math.min(uint256(rightBest), uint256(leftBest)));
    }

    // Taken from https://ethereum.stackexchange.com/a/1518
    function quickSort(
        int256[] memory array,
        int256 left,
        int256 right
    ) internal view {
        int256 i = left;
        int256 j = right;
        if (i == j) {
            return;
        }

        int256 pivot = array[uint256(left + (right - left) / 2)];
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
