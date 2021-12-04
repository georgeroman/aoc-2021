import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day4";

describe(day, () => {
  let numbers: number[];
  let boards: number[][][];
  let boardSize: number;
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    const lines = data.split("\n");
    numbers = lines[0].split(",").map(Number);

    boards = [];
    for (let line of lines.slice(1)) {
      if (line == "") {
        boards.push([]);
      } else {
        const row = line
          .split(" ")
          .filter((x) => x !== "")
          .map(Number);
        boards[boards.length - 1].push(row);
        boardSize = row.length;
      }
    }

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(numbers, boards, boardSize)).toString());
  });

  it("Part 2", async () => {
    // Use `eth_call` since `p2` is not a view method in this case
    console.log(
      (await contract.callStatic.p2(numbers, boards, boardSize)).toString()
    );
  }).timeout(10 * 60 * 1000);
});
