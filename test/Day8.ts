import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day8";

describe(day, () => {
  let values: string[][][];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    values = data
      .split("\n")
      .map((line) => line.split(" | ").map((side) => side.trim().split(" ")));

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(values.map((x) => x[1]))).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    console.log(
      (
        await contract.callStatic.p2(
          values.map((x) => x[0]),
          values.map((x) => x[1])
        )
      ).toString()
    );
  }).timeout(10 * 60 * 1000);
});
