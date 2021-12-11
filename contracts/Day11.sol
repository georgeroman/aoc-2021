// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day11 {
    function p1(uint8[][] memory energies, uint256 numSteps)
        public
        returns (uint256 result)
    {
        for (uint256 step = 0; step < numSteps; step++) {
            for (uint256 i = 0; i < energies.length; i++) {
                for (uint256 j = 0; j < energies[i].length; j++) {
                    result += flash(energies, i, j, step);
                }
            }
        }
    }

    function p2(uint8[][] memory energies) public returns (uint256 step) {
        while (true) {
            uint256 numFlashes;
            for (uint256 i = 0; i < energies.length; i++) {
                for (uint256 j = 0; j < energies[i].length; j++) {
                    numFlashes += flash(energies, i, j, step);
                    if (numFlashes == energies.length**2) {
                        return step + 1;
                    }
                }
            }
            step++;
        }
    }

    mapping(uint256 => mapping(uint256 => mapping(uint256 => bool))) flashed;

    function flash(
        uint8[][] memory energies,
        uint256 i,
        uint256 j,
        uint256 step
    ) internal returns (uint256 numFlashes) {
        if (flashed[step][i][j]) {
            return 0;
        }

        energies[i][j] += 1;
        if (energies[i][j] > 9) {
            flashed[step][i][j] = true;
            energies[i][j] = 0;
            numFlashes++;

            for (int256 x = int256(i) - 1; x <= int256(i) + 1; x++) {
                for (int256 y = int256(j) - 1; y <= int256(j) + 1; y++) {
                    if (
                        x >= 0 &&
                        x < int256(energies[i].length) &&
                        y >= 0 &&
                        y < int256(energies.length) &&
                        (x != int256(i) || y != int256(j))
                    ) {
                        numFlashes += flash(
                            energies,
                            uint256(x),
                            uint256(y),
                            step
                        );
                    }
                }
            }
        }
    }
}
