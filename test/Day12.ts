import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day12";

describe(day, () => {
  let paths: {
    from: string;
    to: string;
  }[];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    paths = data.split("\n").map((line) => {
      const [from, to] = line.trim().split("-");
      return {
        from: ethers.utils.formatBytes32String(from),
        to: ethers.utils.formatBytes32String(to),
      };
    });

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    // Use `eth_call` since `p1` is not a view method in this case
    console.log((await contract.callStatic.p1(paths)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    // Use `eth_call` since `p2` is not a view method in this case
    console.log((await contract.callStatic.p2(paths)).toString());
  }).timeout(10 * 60 * 1000);
});
