import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day9";

describe(day, () => {
  let heights: number[][];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    heights = data.split("\n").map((line) => line.split("").map(Number));

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(heights)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    // Use `eth_call` since `p2` is not a view method in this case
    console.log((await contract.callStatic.p2(heights)).toString());
  }).timeout(10 * 60 * 1000);
});
