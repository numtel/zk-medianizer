import assert from "node:assert";
import { readFileSync } from "node:fs";
import { Circomkit } from "circomkit";

const config = JSON.parse(readFileSync("circomkit.json", "utf-8"));
const circomkit = new Circomkit({...config, verbose: false});

describe("median circuit", () => {
  let circuit;

  const INPUT = [
    {
      values: [ 2,18,6,10,0,0,0,0,0,0 ],
      doubleMedian: 8,
      nearestOver: 10,
      nearestUnder: 6,
      equalAbove: 0,
      equalBelow: 0
    },
    {
      values: [ 0,0,2,4,6,6,10,0,0,0 ],
      doubleMedian: 6,
      nearestOver: 10,
      nearestUnder: 4,
      equalAbove: 1,
      equalBelow: 0
    },
    {
      values: [ 2,4,6,6,6,0,0,0,0,0 ],
      doubleMedian: 6,
      nearestOver: 6,
      nearestUnder: 4,
      equalAbove: 2,
      equalBelow: 0
    },
    {
      values: [ 2,4,6,6,6,10,12,0,0,0 ],
      doubleMedian: 6,
      nearestOver: 6,
      nearestUnder: 6,
      equalAbove: 1,
      equalBelow: 1
    },
    {
      values: [ 2,4,6,6,10,12,0,0,0,0 ],
      doubleMedian: 6,
      nearestOver: 6,
      nearestUnder: 6,
      equalAbove: 1,
      equalBelow: 1
    },
    {
      values: [ 2,4,6,6,12,12,0,0,0,0 ],
      doubleMedian: 6,
      nearestOver: 6,
      nearestUnder: 6,
      equalAbove: 1,
      equalBelow: 1
    },
    {
      values: [ 2,4,6,6,10,12,14,0,0,0 ],
      doubleMedian: 6,
      nearestOver: 10,
      nearestUnder: 6,
      equalAbove: 0,
      equalBelow: 1
    },
    {
      values: [ 2,6,6,10,12,14,0,0,0,0 ],
      doubleMedian: 8,
      nearestOver: 10,
      nearestUnder: 6,
      equalAbove: 0,
      equalBelow: 0
    },
    {
      values: [ 2,4,6,6,6,6,10,12,14,0 ],
      doubleMedian: 6,
      // TODO these values don't matter in this case?
      nearestOver: 8,
      nearestUnder: 6,
      equalAbove: 1,
      equalBelow: 2
    },
    {
      values: [ 14,12,6,6,6,6,10,2,4,0 ],
      doubleMedian: 6,
      // TODO these values don't matter in this case?
      nearestOver: 8,
      nearestUnder: 6,
      equalAbove: 1,
      equalBelow: 2
    },
  ];

  before(async () => {
    circuit = await circomkit.WitnessTester("median", {
      file: "circuits/median",
      template: "Median",
      params: [10, 69]
    });
  });

  it("Should verify the median correctly", async () => {
    for(let input of INPUT) {
      console.log(JSON.stringify(input.values));
      await circuit.expectPass(input);
      // Also check every other value in the list should fail
      for(let value of input.values) {
        if(value !== input.doubleMedian) {
          await circuit.expectFail({ ...input, doubleMedian: value });
        }
      }
    }
  });
})
