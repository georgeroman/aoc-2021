// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day3 {
    function p1(uint256[] memory reports, uint256 numBits)
        public
        pure
        returns (uint256 result)
    {
        uint256[] memory numZeros = new uint256[](numBits);
        uint256[] memory numOnes = new uint256[](numBits);

        for (uint256 i = 0; i < reports.length; i++) {
            for (uint256 b = 1; b <= numBits; b++) {
                if ((reports[i] >> (numBits - b)) & 0x1 == 0) {
                    numZeros[b - 1]++;
                } else {
                    numOnes[b - 1]++;
                }
            }
        }

        uint256 gammaRate;
        uint256 epsilonRate;
        for (uint256 j = 0; j < numBits; j++) {
            if (numOnes[j] > numZeros[j]) {
                gammaRate += 2**(numBits - j - 1);
            } else {
                epsilonRate += 2**(numBits - j - 1);
            }
        }

        result = gammaRate * epsilonRate;
    }

    function p2(uint256[] memory reports, uint256 numBits)
        public
        pure
        returns (uint256 result)
    {
        uint256 oxygenRating = findOxygenGeneratorRating(reports, numBits);
        uint256 co2ScruberRating = findCO2ScruberGeneratorRating(
            reports,
            numBits
        );
        result = oxygenRating * co2ScruberRating;
    }

    function findOxygenGeneratorRating(
        uint256[] memory reports,
        uint256 bitPosition
    ) internal pure returns (uint256 result) {
        if (reports.length == 1) {
            return reports[0];
        }

        uint256 numZeros;
        uint256 numOnes;
        for (uint256 i = 0; i < reports.length; i++) {
            if ((reports[i] >> (bitPosition - 1)) & 0x1 == 0) {
                numZeros++;
            } else {
                numOnes++;
            }
        }

        uint256 k;
        uint256[] memory matchingReports = new uint256[](
            numOnes >= numZeros ? numOnes : numZeros
        );
        for (uint256 j = 0; j < reports.length; j++) {
            if (
                (reports[j] >> (bitPosition - 1)) & 0x1 ==
                (numOnes >= numZeros ? 1 : 0)
            ) {
                matchingReports[k++] = reports[j];
            }
        }

        return findOxygenGeneratorRating(matchingReports, bitPosition - 1);
    }

    function findCO2ScruberGeneratorRating(
        uint256[] memory reports,
        uint256 bitPosition
    ) internal pure returns (uint256 result) {
        if (reports.length == 1) {
            return reports[0];
        }

        uint256 numZeros;
        uint256 numOnes;
        for (uint256 i = 0; i < reports.length; i++) {
            if ((reports[i] >> (bitPosition - 1)) & 0x1 == 0) {
                numZeros++;
            } else {
                numOnes++;
            }
        }

        uint256 k;
        uint256[] memory matchingReports = new uint256[](
            numZeros <= numOnes ? numZeros : numOnes
        );
        for (uint256 j = 0; j < reports.length; j++) {
            if (
                (reports[j] >> (bitPosition - 1)) & 0x1 ==
                (numZeros <= numOnes ? 0 : 1)
            ) {
                matchingReports[k++] = reports[j];
            }
        }

        return findCO2ScruberGeneratorRating(matchingReports, bitPosition - 1);
    }
}
