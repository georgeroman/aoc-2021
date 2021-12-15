// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day15 {
    PriorityQueue internal pq = new PriorityQueue();
    mapping(uint256 => bool) internal visited;

    function p1(uint256[][] memory map) public returns (uint256) {
        // Dijkstra

        uint256[][] memory dist = new uint256[][](map.length);
        for (uint256 i = 0; i < map.length; i++) {
            dist[i] = new uint256[](map[i].length);
            for (uint256 j = 0; j < map[i].length; j++) {
                dist[i][j] = type(uint256).max;
            }
        }
        dist[0][0] = 0;

        pq.insert(0, 0 * map.length + 0);
        while (pq.currentSize() != 0) {
            (uint256 distance, uint256 current) = pq.delMin();

            uint256 i = current / map.length;
            uint256 j = current % map[i].length;
            visited[current] = true;

            uint256[] memory neighbors = new uint256[](4);
            uint256 neighborsLen;
            if (i > 0) {
                neighbors[neighborsLen++] = (i - 1) * map.length + j;
            }
            if (i < map.length - 1) {
                neighbors[neighborsLen++] = (i + 1) * map.length + j;
            }
            if (j > 0) {
                neighbors[neighborsLen++] = i * map.length + j - 1;
            }
            if (j < map[i].length - 1) {
                neighbors[neighborsLen++] = i * map.length + j + 1;
            }

            for (uint256 k = 0; k < neighborsLen; k++) {
                if (!visited[neighbors[k]]) {
                    uint256 ni = neighbors[k] / map.length;
                    uint256 nj = neighbors[k] % map[i].length;

                    uint256 oldDist = dist[ni][nj];
                    uint256 newDist = dist[i][j] + map[ni][nj];
                    if (newDist < oldDist) {
                        pq.insert(newDist, neighbors[k]);
                        dist[ni][nj] = newDist;
                    }
                }
            }
        }

        return dist[map.length - 1][map[map.length - 1].length - 1];
    }
}

// Taken from:
// https://github.com/omgnetwork/plasma-mvp/blob/82e26b5efadb57c00683f18f11758f59c7a98876/plasma/root_chain/contracts/PriorityQueue.sol
contract PriorityQueue {
    uint256[] internal heapList;
    uint256 public currentSize;

    constructor() {
        heapList = [0];
        currentSize = 0;
    }

    function insert(uint256 _priority, uint256 _value) public {
        uint256 element = (_priority << 128) | _value;
        heapList.push(element);
        currentSize = currentSize + 1;
        _percUp(currentSize);
    }

    function getMin() public view returns (uint256, uint256) {
        return _splitElement(heapList[1]);
    }

    function delMin() public returns (uint256, uint256) {
        uint256 retVal = heapList[1];
        heapList[1] = heapList[currentSize];
        delete heapList[currentSize];
        currentSize = currentSize - 1;
        _percDown(1);
        heapList.pop();
        return _splitElement(retVal);
    }

    function _minChild(uint256 _index) private view returns (uint256) {
        if (_index / 2 + 1 > currentSize) {
            return _index * 2;
        } else {
            // Fix from the original
            if (
                _index * 2 + 1 > heapList.length - 1 ||
                heapList[_index * 2] < heapList[_index * 2 + 1]
            ) {
                return _index * 2;
            } else {
                return _index * 2 + 1;
            }
        }
    }

    function _percUp(uint256 _index) private {
        uint256 index = _index;
        uint256 j = index;
        uint256 newVal = heapList[index];
        while (newVal < heapList[index / 2]) {
            heapList[index] = heapList[index / 2];
            index = index / 2;
        }
        if (index != j) heapList[index] = newVal;
    }

    function _percDown(uint256 _index) private {
        uint256 index = _index;
        uint256 j = index;
        uint256 newVal = heapList[index];
        uint256 mc = _minChild(index);
        while (mc <= currentSize && newVal > heapList[mc]) {
            heapList[index] = heapList[mc];
            index = mc;
            mc = _minChild(index);
        }
        if (index != j) heapList[index] = newVal;
    }

    function _splitElement(uint256 _element)
        private
        pure
        returns (uint256, uint256)
    {
        uint256 priority = _element >> 128;
        uint256 value = uint256(uint128(_element));
        return (priority, value);
    }
}
