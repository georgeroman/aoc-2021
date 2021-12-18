// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day18 {
    struct Item {
        uint256 value;
        uint256 parenCount;
    }

    Item[] internal finalItems;

    function p1(Item[][] memory items) public returns (uint256 result) {
        for (uint256 i = 0; i < items[0].length; i++) {
            finalItems.push(Item(items[0][i].value, items[0][i].parenCount));
        }

        for (uint256 i = 1; i < items.length; i++) {
            for (uint256 k = 0; k < finalItems.length; k++) {
                finalItems[k].parenCount++;
            }
            for (uint256 k = 0; k < items[i].length; k++) {
                finalItems.push(
                    Item(items[i][k].value, items[i][k].parenCount + 1)
                );
            }

            bool stop;
            while (!stop) {
                stop = true;

                // Explode
                for (uint256 k = 0; k < finalItems.length - 1; k++) {
                    if (
                        finalItems[k].parenCount == 5 &&
                        finalItems[k + 1].parenCount == 5
                    ) {
                        if (k > 0) {
                            finalItems[k - 1].value += finalItems[k].value;
                        }
                        if (k + 2 < finalItems.length) {
                            finalItems[k + 2].value += finalItems[k + 1].value;
                        }

                        finalItems[k].value = 0;
                        finalItems[k].parenCount--;

                        for (uint256 j = k + 2; j < finalItems.length; j++) {
                            finalItems[j - 1] = finalItems[j];
                        }
                        finalItems.pop();

                        stop = false;
                        break;
                    }
                }

                if (!stop) {
                    continue;
                }

                // Split
                for (uint256 k = 0; k < finalItems.length; k++) {
                    if (finalItems[k].value >= 10) {
                        uint256 value = finalItems[k].value;

                        finalItems[k].value = value / 2;
                        finalItems[k].parenCount++;

                        finalItems.push(Item(0, 0));
                        for (
                            uint256 j = finalItems.length - 1;
                            j > k + 1;
                            j--
                        ) {
                            finalItems[j] = finalItems[j - 1];
                        }
                        finalItems[k + 1].value = (value + 1) / 2;
                        finalItems[k + 1].parenCount = finalItems[k].parenCount;

                        stop = false;
                        break;
                    }
                }
            }
        }

        while (finalItems.length > 1) {
            for (uint256 i = 0; i < finalItems.length; i++) {
                if (
                    i < finalItems.length - 1 &&
                    finalItems[i].parenCount == finalItems[i + 1].parenCount
                ) {
                    finalItems[i].value =
                        3 *
                        finalItems[i].value +
                        2 *
                        finalItems[i + 1].value;
                    finalItems[i].parenCount--;

                    for (uint256 j = i + 2; j < finalItems.length; j++) {
                        finalItems[j - 1] = finalItems[j];
                    }
                    finalItems.pop();
                }
            }
        }

        result = finalItems[0].value;
    }

    mapping(uint256 => Item[]) internal finalItemsTries;

    function p2(Item[][] memory items) public returns (uint256 result) {
        uint256 step;
        for (uint256 x = 0; x < items.length; x++) {
            for (uint256 y = 0; y < items.length; y++) {
                if (x != y) {
                    step++;

                    for (uint256 k = 0; k < items[x].length; k++) {
                        finalItemsTries[step].push(
                            Item(items[x][k].value, items[x][k].parenCount + 1)
                        );
                    }
                    for (uint256 k = 0; k < items[y].length; k++) {
                        finalItems.push(
                            Item(items[y][k].value, items[y][k].parenCount + 1)
                        );
                    }

                    bool stop;
                    while (!stop) {
                        stop = true;

                        // Explode
                        for (
                            uint256 k = 0;
                            k < finalItemsTries[step].length - 1;
                            k++
                        ) {
                            if (
                                finalItemsTries[step][k].parenCount == 5 &&
                                finalItemsTries[step][k + 1].parenCount == 5
                            ) {
                                if (k > 0) {
                                    finalItemsTries[step][k - 1]
                                        .value += finalItemsTries[step][k]
                                        .value;
                                }
                                if (k + 2 < finalItemsTries[step].length) {
                                    finalItemsTries[step][k + 2]
                                        .value += finalItemsTries[step][k + 1]
                                        .value;
                                }

                                finalItemsTries[step][k].value = 0;
                                finalItemsTries[step][k].parenCount--;

                                for (
                                    uint256 j = k + 2;
                                    j < finalItemsTries[step].length;
                                    j++
                                ) {
                                    finalItemsTries[step][
                                        j - 1
                                    ] = finalItemsTries[step][j];
                                }
                                finalItemsTries[step].pop();

                                stop = false;
                                break;
                            }
                        }

                        if (!stop) {
                            continue;
                        }

                        // Split
                        for (
                            uint256 k = 0;
                            k < finalItemsTries[step].length;
                            k++
                        ) {
                            if (finalItemsTries[step][k].value >= 10) {
                                uint256 value = finalItemsTries[step][k].value;

                                finalItemsTries[step][k].value = value / 2;
                                finalItemsTries[step][k].parenCount++;

                                finalItemsTries[step].push(Item(0, 0));
                                for (
                                    uint256 j = finalItemsTries[step].length -
                                        1;
                                    j > k + 1;
                                    j--
                                ) {
                                    finalItemsTries[step][j] = finalItemsTries[
                                        step
                                    ][j - 1];
                                }
                                finalItemsTries[step][k + 1].value =
                                    (value + 1) /
                                    2;
                                finalItemsTries[step][k + 1]
                                    .parenCount = finalItemsTries[step][k]
                                    .parenCount;

                                stop = false;
                                break;
                            }
                        }
                    }

                    while (finalItemsTries[step].length > 1) {
                        for (
                            uint256 i = 0;
                            i < finalItemsTries[step].length;
                            i++
                        ) {
                            if (
                                i < finalItemsTries[step].length - 1 &&
                                finalItemsTries[step][i].parenCount ==
                                finalItemsTries[step][i + 1].parenCount
                            ) {
                                finalItemsTries[step][i].value =
                                    3 *
                                    finalItemsTries[step][i].value +
                                    2 *
                                    finalItemsTries[step][i + 1].value;
                                finalItemsTries[step][i].parenCount--;

                                for (
                                    uint256 j = i + 2;
                                    j < finalItemsTries[step].length;
                                    j++
                                ) {
                                    finalItemsTries[step][
                                        j - 1
                                    ] = finalItemsTries[step][j];
                                }
                                finalItemsTries[step].pop();
                            }
                        }
                    }

                    result = finalItemsTries[step][0].value > result
                        ? finalItemsTries[step][0].value
                        : result;
                }
            }
        }
    }
}
