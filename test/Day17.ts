import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day17";

describe(day, () => {
  let lowX: number;
  let highX: number;
  let lowY: number;
  let highY: number;
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    [lowX, highX, lowY, highY] =
      /target area: x=(\-?\d+)..(\-?\d+), y=(\-?\d+)..(\-?\d+)/g
        .exec(data)!
        .slice(1, 5)
        .map(Number);

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(lowY, highY)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    // Use `eth_call` since `p2` is not a view method in this case
    console.log(
      (await contract.callStatic.p2(lowX, highX, lowY, highY)).toString()
    );
  }).timeout(10 * 60 * 1000);
});
