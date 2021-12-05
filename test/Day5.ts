import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day5";

describe(day, () => {
  let lines: {
    start: { x: number; y: number };
    end: { x: number; y: number };
  }[];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    lines = data.split("\n").map((x) => {
      const [start, end] = x.split(" -> ").map((x) => x.split(",").map(Number));
      return {
        start: {
          x: start[0],
          y: start[1],
        },
        end: {
          x: end[0],
          y: end[1],
        },
      };
    });

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    // Use `eth_call` since `p1` is not a view method in this case
    console.log((await contract.callStatic.p1(lines)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    // Use `eth_call` since `p2` is not a view method in this case
    console.log((await contract.callStatic.p2(lines)).toString());
  }).timeout(10 * 60 * 1000);
});
