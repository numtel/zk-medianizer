// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Median2} from "../src/Median2.sol";

// In order to see gas estimations
contract Example {
  uint256[] public values;

  function length() external view returns(uint256) {
    return values.length;
  }

  function push(uint256 value) external {
    values.push(value);
  }
  function validate(uint256 median) external view returns(bool) {
    return Median2.validate(values, median);
  }
}

contract Median2Test is Test {
  Example values;

  function setUp() public {
    values = new Example();
  }

  function testMedian(uint256 exception) internal {
    assertEq(values.validate(exception), true);
    for(uint256 i = 0; i < values.length(); i++) {
      assertEq(values.validate(values.values(i)), values.values(i) == exception);
    }
  }

  function testBasic1() public {
    values.push(0);
    values.push(0);
    values.push(1);
    values.push(2);
    values.push(3);
    values.push(3);
    values.push(5);
    testMedian(3);
  }

  function testBasic2() public {
    values.push(1);
    values.push(2);
    values.push(3);
    values.push(3);
    values.push(5);
    testMedian(3);
  }

  function testBasic3() public {
    values.push(1);
    values.push(2);
    values.push(3);
    values.push(3);
    values.push(3);
    testMedian(3);
  }

  function testBasic4() public {
    values.push(1);
    values.push(2);
    values.push(3);
    values.push(3);
    values.push(3);
    values.push(5);
    values.push(6);
    testMedian(3);
  }

  function testBasic5() public {
    values.push(1);
    values.push(2);
    values.push(3);
    values.push(3);
    values.push(5);
    values.push(6);
    testMedian(3);
  }

  function testBasic6() public {
    values.push(1);
    values.push(2);
    values.push(3);
    values.push(3);
    values.push(5);
    values.push(6);
    values.push(7);
    testMedian(3);
  }

  function testBasic7() public {
    values.push(1);
    values.push(3);
    values.push(3);
    values.push(5);
    values.push(6);
    values.push(7);
    testMedian(4);
  }

  function testBasic8() public {
    values.push(1);
    values.push(2);
    values.push(3);
    values.push(3);
    values.push(3);
    values.push(3);
    values.push(5);
    values.push(6);
    values.push(7);
    testMedian(3);
  }

  function testBasic9() public {
    values.push(7);
    values.push(6);
    values.push(3);
    values.push(3);
    values.push(3);
    values.push(3);
    values.push(5);
    values.push(1);
    values.push(2);
    testMedian(3);
  }

  function testBig() public {
    for(uint256 i = 0; i < 1000; i++) {
      values.push(i);
    }
    testMedian(500);
  }
}

