import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day3";

describe(day, () => {
  let reports: number[];
  let numBits: number;
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    reports = data.split("\n").map((x) => {
      numBits = x.length;
      return parseInt(x, 2);
    });

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(reports, numBits)).toString());
  });

  it("Part 2", async () => {
    console.log((await contract.p2(reports, numBits)).toString());
  });
});
