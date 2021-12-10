import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day10";

describe(day, () => {
  let lines: string[];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    lines = data.split("\n").map((line) => line.trim());

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(lines)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    console.log((await contract.p2(lines)).toString());
  }).timeout(10 * 60 * 1000);
});
