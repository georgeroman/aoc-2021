import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day21";

describe(day, () => {
  let p1Start: number;
  let p2Start: number;
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    [p1Start, p2Start] = data
      .split("\n")
      .map((line) => Number(line.split(": ")[1]));

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(p1Start, p2Start)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    // Use `eth_call` since `p2` is not a view method in this case
    console.log((await contract.callStatic.p2(p1Start, p2Start)).toString());
  }).timeout(10 * 60 * 1000);
});
