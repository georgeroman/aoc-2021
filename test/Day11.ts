import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day11";

describe(day, () => {
  let energies: number[][];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    energies = data
      .split("\n")
      .map((line) => line.trim().split("").map(Number));

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    // Use `eth_call` since `p1` is not a view method in this case
    console.log((await contract.callStatic.p1(energies, 100)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    // Use `eth_call` since `p2` is not a view method in this case
    console.log((await contract.callStatic.p2(energies)).toString());
  }).timeout(10 * 60 * 1000);
});
