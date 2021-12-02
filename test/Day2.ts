import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day2";

describe(day, () => {
  let instructions: { direction: number; units: number }[];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    instructions = data.split("\n").map((x) => {
      const [direction, units] = x.split(" ");
      return {
        direction: direction == "forward" ? 0 : direction == "down" ? 1 : 2,
        units: Number(units),
      };
    });

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(instructions)).toString());
  });

  it("Part 2", async () => {
    console.log((await contract.p2(instructions)).toString());
  });
});
