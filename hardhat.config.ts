import { HardhatUserConfig } from "hardhat/types";

import "@nomiclabs/hardhat-waffle";

const config: HardhatUserConfig = {
  solidity: "0.8.4",
  networks: {
    hardhat: {
      // No way we can fit AoC within the default 30m gas
      blockGasLimit: 1_000_000_000,
    },
  },
};

export default config;
