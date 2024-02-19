// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Linear time O(n) median verification algorithm
// Author: numtel <ben@latenightsketches.com>
library Median2 {
  error UNEXPECTED_ERROR();

  function validate(uint256[] memory values, uint256 newMedian) internal pure returns(bool) {
    // Verify that new median is correct without sorting the array
    uint256 countUnder;
    uint256 countOver;
    uint256 countEqual;
    uint256 nearestUnder;
    uint256 nearestOver = type(uint256).max;

    for(uint i = 0; i < values.length; i++) {
      if(values[i] == 0) {
        // noop
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
      } else {
        revert UNEXPECTED_ERROR();
      }
    }

    if(countEqual >= 1 && countOver == countUnder) return true;
    else if(countEqual > 1) {
      while(countEqual > 1) {
        if(countUnder < countOver) {
          nearestUnder = newMedian;
          countUnder++;
          countEqual--;
        } else if(countUnder > countOver) {
          nearestOver = newMedian;
          countOver++;
          countEqual--;
        } else {
          return true;
        }
      }
      return countUnder == countOver;
    } else {
      return (countUnder == countOver) && (newMedian == (nearestOver + nearestUnder) / 2);
    }
  }

}
