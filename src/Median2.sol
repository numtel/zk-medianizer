// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Linear time O(n) median verification algorithm
// Author: numtel <ben@latenightsketches.com>
library Median2 {
  function validate(uint256[] memory values, uint256 newMedian) internal pure returns(bool) {
    uint256 countZero;
    uint256 countUnder;
    uint256 countOver;
    uint256 countEqual;
    uint256 nearestUnder;
    uint256 nearestOver = type(uint256).max;

    for(uint i = 0; i < values.length; i++) {
      if(values[i] == 0) {
        countZero++;
      } else if(values[i] > newMedian) {
        countOver++;
        if(values[i] < nearestOver) {
          nearestOver = values[i];
        }
      } else if(values[i] < newMedian) {
        countUnder++;
        if(values[i] > nearestUnder) {
          nearestUnder = values[i];
        }
      } else if(values[i] == newMedian) {
        countEqual++;
      }
    }

    // Balance out duplicates of the median
    while(countEqual > 1 && countOver != countUnder) {
      if(countUnder < countOver) {
        nearestUnder = newMedian;
        countUnder++;
        countEqual--;
      } else if(countUnder > countOver) {
        nearestOver = newMedian;
        countOver++;
        countEqual--;
      }
    }

    bool countIsOdd = (values.length - countZero) % 2 == 1;
    return (countUnder == countOver)
      && (countIsOdd
        || (countEqual >= 2 || newMedian == (nearestOver + nearestUnder) / 2));
  }
}
