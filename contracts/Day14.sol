// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day14 {
    struct InsertionRule {
        bytes2 pair;
        bytes1 element;
    }

    mapping(bytes2 => bytes1) internal rules;

    struct Item {
        bytes1 value;
        uint256 next;
    }

    mapping(uint256 => Item) internal items;
    uint256 internal nextSlot;

    mapping(bytes1 => uint256) internal counts;

    function p1(string memory start, InsertionRule[] memory insertionRules)
        public
        returns (uint256)
    {
        items[nextSlot++].value = bytes(start)[0];

        Item storage current = items[0];
        for (uint256 i = 1; i < bytes(start).length; i++) {
            current.next = nextSlot++;
            current = items[current.next];
            current.value = bytes(start)[i];
        }

        for (uint256 i = 0; i < insertionRules.length; i++) {
            rules[insertionRules[i].pair] = insertionRules[i].element;
        }

        for (uint256 step = 0; step < 10; step++) {
            current = items[0];
            while (current.next != 0) {
                bytes2 pair = bytes2(
                    (uint16(uint8(current.value)) << 8) +
                        uint16(uint8(items[current.next].value))
                );
                if (rules[pair] != 0x00) {
                    Item storage newItem = items[nextSlot];
                    newItem.value = rules[pair];
                    newItem.next = current.next;
                    current.next = nextSlot;

                    nextSlot++;

                    current = items[newItem.next];
                } else {
                    current = items[current.next];
                }
            }
        }

        current = items[0];
        while (current.next != 0) {
            counts[current.value]++;
            current = items[current.next];

            if (current.next == 0) {
                counts[current.value]++;
            }
        }

        uint256 minCount = type(uint256).max;
        uint256 maxCount;
        current = items[0];
        while (current.next != 0) {
            if (counts[current.value] > maxCount) {
                maxCount = counts[current.value];
            }
            if (counts[current.value] < minCount) {
                minCount = counts[current.value];
            }
            current = items[current.next];

            if (current.next == 0) {
                if (counts[current.value] > maxCount) {
                    maxCount = counts[current.value];
                }
                if (counts[current.value] < minCount) {
                    minCount = counts[current.value];
                }
            }
        }

        return maxCount - minCount;
    }

    function p2(string memory start, InsertionRule[] memory insertionRules)
        public
        returns (uint256)
    {
        for (uint256 i = 0; i < insertionRules.length; i++) {
            rules[insertionRules[i].pair] = insertionRules[i].element;
        }

        uint256[] memory totalCounts = new uint256[](26);

        bytes2[] memory pairs = new bytes2[](20);
        uint256 pairsLen;
        for (uint256 i = 1; i < bytes(start).length; i++) {
            pairs[pairsLen++] = bytes2(
                (uint16(uint8(bytes(start)[i - 1])) << 8) +
                    uint16(uint8(bytes(start)[i]))
            );

            uint256[] storage pairCounts = compute(pairs[pairsLen - 1], 40);
            for (uint256 k = 0; k < 26; k++) {
                totalCounts[k] += pairCounts[k];
            }
        }

        for (uint256 k = 0; k < 26; k++) {
            totalCounts[k] = (totalCounts[k] + 1) / 2;
        }

        uint256 minCount = type(uint256).max;
        uint256 maxCount;
        for (uint256 i = 0; i < 26; i++) {
            if (totalCounts[i] != 0) {
                if (totalCounts[i] > maxCount) {
                    maxCount = totalCounts[i];
                }
                if (totalCounts[i] < minCount) {
                    minCount = totalCounts[i];
                }
            }
        }

        return maxCount - minCount;
    }

    mapping(bytes2 => mapping(uint256 => uint256[])) cache;

    function compute(bytes2 pair, uint256 numSteps)
        internal
        returns (uint256[] storage)
    {
        if (cache[pair][numSteps].length != 0) {
            return cache[pair][numSteps];
        }

        if (numSteps == 0) {
            for (bytes1 x = "A"; x <= "Z"; x = bytes1(uint8(x) + 1)) {
                if (pair[0] == x && pair[1] == x) {
                    cache[pair][numSteps].push(2);
                } else if (pair[0] == x || pair[1] == x) {
                    cache[pair][numSteps].push(1);
                } else {
                    cache[pair][numSteps].push(0);
                }
            }
        } else {
            bytes1 element = rules[pair];
            if (element != 0x00) {
                bytes2 leftPair = bytes2(
                    (uint16(uint8(pair[0])) << 8) + uint16(uint8(element))
                );
                uint256[] storage leftResult = compute(leftPair, numSteps - 1);

                bytes2 rightPair = bytes2(
                    (uint16(uint8(element)) << 8) + uint16(uint8(pair[1]))
                );
                uint256[] storage rightResult = compute(
                    rightPair,
                    numSteps - 1
                );

                for (uint256 i = 0; i < 26; i++) {
                    cache[pair][numSteps].push(leftResult[i] + rightResult[i]);
                }
            } else {
                return compute(pair, numSteps - 1);
            }
        }

        return cache[pair][numSteps];
    }
}
