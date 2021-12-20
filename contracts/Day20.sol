// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Day20 {
    uint256 internal step;

    function p1(bytes memory algorithm, bytes[] memory inputImage)
        public
        returns (uint256 result)
    {
        bytes[] memory image0 = applyAlgorithm(algorithm, inputImage);
        step++;
        bytes[] memory image1 = applyAlgorithm(algorithm, image0);
        for (uint256 i = 0; i < image1.length; i++) {
            for (uint256 j = 0; j < image1.length; j++) {
                if (image1[i][j] == "#") {
                    result++;
                }
            }
        }
    }

    function p2(bytes memory algorithm, bytes[] memory inputImage)
        public
        returns (uint256 result)
    {
        bytes[] memory finalImage;
        for (uint256 i = 1; i <= 50; i++) {
            finalImage = applyAlgorithm(algorithm, inputImage);
            inputImage = finalImage;
            step++;
        }

        for (uint256 i = 0; i < finalImage.length; i++) {
            for (uint256 j = 0; j < finalImage.length; j++) {
                if (finalImage[i][j] == "#") {
                    result++;
                }
            }
        }
    }

    function applyAlgorithm(bytes memory algorithm, bytes[] memory inputImage)
        internal
        view
        returns (bytes[] memory enhancedInputImage)
    {
        enhancedInputImage = new bytes[](inputImage.length + 2);
        for (int256 i = -1; i < int256(inputImage.length) + 1; i++) {
            enhancedInputImage[uint256(i + 1)] = new bytes(
                inputImage.length + 2
            );
            for (int256 j = -1; j < int256(inputImage.length) + 1; j++) {
                bytes1 byte0 = getByte(inputImage, i - 1, j - 1);
                bytes1 byte1 = getByte(inputImage, i - 1, j);
                bytes1 byte2 = getByte(inputImage, i - 1, j + 1);
                bytes1 byte3 = getByte(inputImage, i, j - 1);
                bytes1 byte4 = getByte(inputImage, i, j);
                bytes1 byte5 = getByte(inputImage, i, j + 1);
                bytes1 byte6 = getByte(inputImage, i + 1, j - 1);
                bytes1 byte7 = getByte(inputImage, i + 1, j);
                bytes1 byte8 = getByte(inputImage, i + 1, j + 1);

                enhancedInputImage[uint256(i + 1)][uint256(j + 1)] = algorithm[
                    toNumber(
                        abi.encodePacked(
                            byte0,
                            byte1,
                            byte2,
                            byte3,
                            byte4,
                            byte5,
                            byte6,
                            byte7,
                            byte8
                        )
                    )
                ];
            }
        }
    }

    function getByte(
        bytes[] memory inputImage,
        int256 i,
        int256 j
    ) internal view returns (bytes1) {
        if (
            i < 0 ||
            j < 0 ||
            i >= int256(inputImage.length) ||
            j >= int256(inputImage.length)
        ) {
            return step % 2 == 0 ? bytes1(".") : bytes1("#");
        } else {
            return inputImage[uint256(i)][uint256(j)];
        }
    }

    function toNumber(bytes memory input)
        internal
        pure
        returns (uint256 result)
    {
        for (uint256 i = 0; i < input.length; i++) {
            result <<= 1;
            if (input[i] == "#") {
                result++;
            }
        }
    }
}
