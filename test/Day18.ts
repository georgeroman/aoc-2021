import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day18";

describe(day, () => {
  let items: {
    value: number;
    parenCount: number;
  }[][] = [];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    data.split("\n").forEach((line) => {
      let localItems: {
        value: number;
        parenCount: number;
      }[] = [];

      let parenCount = 0;
      for (let i = 0; i < line.length; i++) {
        if (line[i] === "[") {
          parenCount++;
        } else if (line[i] === "]") {
          parenCount--;
        } else if (line[i] !== ",") {
          localItems.push({
            value: Number(line[i]),
            parenCount,
          });
        }
      }

      items.push(localItems);
    });

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    // Use `eth_call` since `p1` is not a view method in this case
    console.log((await contract.callStatic.p1(items)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    // Use `eth_call` since `p2` is not a view method in this case
    console.log((await contract.callStatic.p2(items)).toString());
  }).timeout(10 * 60 * 1000);
});
