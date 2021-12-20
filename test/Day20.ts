import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day20";

describe(day, () => {
  let algorithm: string;
  let inputImage: string[];
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    const lines = data.split("\n");
    algorithm = lines[0];
    inputImage = lines.slice(2);

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    // Use `eth_call` since `p1` is not a view method in this case
    console.log(
      (
        await contract.callStatic.p1(
          ethers.utils.toUtf8Bytes(algorithm),
          inputImage.map((x) => ethers.utils.toUtf8Bytes(x))
        )
      ).toString()
    );
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    // Use `eth_call` since `p2` is not a view method in this case
    console.log(
      (
        await contract.callStatic.p2(
          ethers.utils.toUtf8Bytes(algorithm),
          inputImage.map((x) => ethers.utils.toUtf8Bytes(x))
        )
      ).toString()
    );
  }).timeout(10 * 60 * 1000);
});
