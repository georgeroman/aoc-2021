import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day13";

describe(day, () => {
  let paper: number[][] = [];
  let points: { x: number; y: number }[] = [];
  let folds: { kind: string; value: number }[] = [];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    const lines = data.split("\n");

    let i = 0;
    while (lines[i] !== "") {
      if (lines[i] === "") {
        break;
      } else {
        const [x, y] = lines[i].split(",").map(Number);
        points.push({ x, y });
      }
      i++;
    }

    i++;
    while (i < lines.length) {
      const [, , fold] = lines[i].split(" ");
      const [kind, value] = fold.split("=");
      folds.push({
        kind: ethers.utils.formatBytes32String(kind),
        value: Number(value),
      });
      i++;
    }

    let maxX = 0;
    let maxY = 0;
    for (const { x, y } of points) {
      maxX = x > maxX ? x : maxX;
      maxY = y > maxY ? y : maxY;
    }

    for (let y = 0; y <= maxY; y++) {
      paper.push([]);
      for (let x = 0; x <= maxX; x++) {
        paper[y].push(0);
      }
    }

    for (const { x, y } of points) {
      paper[y][x] = 1;
    }

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log((await contract.p1(paper, points, folds)).toString());
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    console.log((await contract.p2(paper, points, folds)).toString());
  }).timeout(10 * 60 * 1000);
});
