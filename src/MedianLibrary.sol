// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Can't import from the repo because it uses solidity 0.6.0
import "./BokkyPooBahsRedBlackTreeLibrary.sol";

library MedianLibrary {
  using BokkyPooBahsRedBlackTreeLibrary for BokkyPooBahsRedBlackTreeLibrary.Tree;

  struct Data {
    BokkyPooBahsRedBlackTreeLibrary.Tree tree;
    mapping(uint => uint) counts;
    mapping(uint256 => uint) values;
    uint totalCount;
  }

  // Value must be >0, except if a value is already set,
  // passing value of 0 will unset for that id.
  function set(Data storage self, uint256 id, uint value) internal {
    if(self.values[id] != 0) {
      if(self.values[id] == value) return;
      // Changing existing value, remove old
      self.totalCount--;
      self.counts[self.values[id]]--;
      if(self.counts[self.values[id]] == 0) {
        self.tree.remove(self.values[id]);
      }
      if(value == 0) return;
    }
    require(value > 0);
    self.totalCount++;
    self.counts[value]++;
    self.values[id] = value;
    if(!self.tree.exists(value)) {
      self.tree.insert(value);
    }
  }

  function median(Data storage self) internal view returns (uint) {
    if(self.totalCount == 0) return 0;
    if(self.totalCount == 1) return self.tree.first();
    bool isEven = self.totalCount % 2 == 0;
    uint midPos = self.totalCount / 2;
    uint curPos = self.tree.first();
    uint soFar = self.counts[curPos];
    while(soFar < midPos) {
      curPos = self.tree.next(curPos);
      soFar += self.counts[curPos];
    }
    if(isEven && soFar == midPos) {
      curPos = (curPos + self.tree.next(curPos)) / 2;
    } else if(!isEven && soFar <= midPos) {
      curPos = self.tree.next(curPos);
    }
    return curPos;
  }
}
