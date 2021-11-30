import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day1";

describe(day, () => {
  let data: any;
  let contract: Contract;

  beforeEach(async () => {
    data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {});

  it("Part 2", async () => {});
});
