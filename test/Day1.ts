import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day1";

describe(day, () => {
  let measurements: number[];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    measurements = data.split("\n").map(Number);

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(measurements)).toString());
  });

  it("Part 2", async () => {
    console.log((await contract.p2(measurements)).toString());
  });
});
