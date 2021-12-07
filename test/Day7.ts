import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day7";

describe(day, () => {
  let positions: number[];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    positions = data.split(",").map(Number);

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(positions)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    console.log((await contract.p2(positions)).toString());
  }).timeout(10 * 60 * 1000);
});
