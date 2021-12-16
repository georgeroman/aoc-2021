import { Contract } from "@ethersproject/contracts";
import * as fs from "fs";
import { ethers } from "hardhat";

const day = "Day16";

describe(day, () => {
  let input: string;
  let contract: Contract;

  beforeEach(async () => {
    const data = await fs.promises.readFile(`./inputs/${day}.txt`, "utf-8");
    input = data
      .split("")
      .map((x) => {
        switch (x.toLowerCase()) {
          case "0":
            return "0000";
          case "1":
            return "0001";
          case "2":
            return "0010";
          case "3":
            return "0011";
          case "4":
            return "0100";
          case "5":
            return "0101";
          case "6":
            return "0110";
          case "7":
            return "0111";
          case "8":
            return "1000";
          case "9":
            return "1001";
          case "a":
            return "1010";
          case "b":
            return "1011";
          case "c":
            return "1100";
          case "d":
            return "1101";
          case "e":
            return "1110";
          case "f":
            return "1111";
          default:
            return "";
        }
      })
      .join("");

    const contractFactory = await ethers.getContractFactory(day);
    contract = await contractFactory.deploy();
  });

  it("Part 1", async () => {
    console.log(
      (await contract.p1(ethers.utils.toUtf8Bytes(input))).toString()
    );
  }).timeout(10 * 60 * 1000);

  it("Part 2", async () => {
    console.log(
      (await contract.p2(ethers.utils.toUtf8Bytes(input))).toString()
    );
  }).timeout(10 * 60 * 1000);
});
