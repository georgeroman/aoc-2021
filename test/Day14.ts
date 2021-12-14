import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day14";

describe(day, () => {
  let start: string;
  let insertionRules: { pair: Uint8Array; element: Uint8Array }[] = [];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    const lines = data.split("\n");

    start = lines[0].trim();
    for (let i = 2; i < lines.length; i++) {
      const [pair, element] = lines[i].split(" -> ");
      insertionRules.push({
        pair: new TextEncoder().encode(pair),
        element: new TextEncoder().encode(element),
      });
    }

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    // Use `eth_call` since `p1` is not a view method in this case
    console.log(
      (await contract.callStatic.p1(start, insertionRules)).toString()
    );
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    // Use `eth_call` since `p2` is not a view method in this case
    console.log(
      (await contract.callStatic.p2(start, insertionRules)).toString()
    );
  }).timeout(10 * 60 * 1000);
});
