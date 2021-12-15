import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day15";

describe(day, () => {
  let map: number[][];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    map = data.split("\n").map((line) => line.split("").map(Number));

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    // Use `eth_call` since `p1` is not a view method in this case
    console.log((await contract.callStatic.p1(map)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    const newMap = Array(map.length * 5).fill(undefined);
    for (let i = 0; i < newMap.length; i++) {
      newMap[i] = Array(map.length * 5).fill(0);
    }
    for (let i = 0; i < map.length; i++) {
      for (let j = 0; j < map.length; j++) {
        for (let ii = 0; ii < 5; ii++) {
          for (let jj = 0; jj < 5; jj++) {
            let newRisk = map[i][j] + ii + jj;
            if (newRisk >= 10) {
              newRisk -= 9;
            }
            newMap[ii * map.length + i][jj * map.length + j] = newRisk;
          }
        }
      }
    }

    // Use `eth_call` since `p1` is not a view method in this case
    console.log((await contract.callStatic.p1(newMap)).toString());
  }).timeout(10 * 60 * 1000);
});
