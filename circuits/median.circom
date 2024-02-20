pragma circom 2.1.5;

// include "poseidon.circom";

// Linear time O(n) median verification algorithm
// Author: numtel <ben@latenightsketches.com>
template Median(MAX_COUNT) {
  signal input values[MAX_COUNT];
  signal input newMedian;
  signal output valid;

  var countZero;
  var countUnder;
  var countOver;
  var countEqual;
  var nearestUnder;
  // i.e. field size - 1
  var nearestOver = 21888242871839275222246405745257275088548364400416034343698204186575808495616;

  for(var i=0; i<MAX_COUNT; i++) {
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

  if(countEqual > 1 && countOver != countUnder) {
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
  }
  var countIsOdd = (MAX_COUNT - countZero) % 2;
  log(countOver, countEqual, countUnder, nearestUnder, nearestOver, countIsOdd);

  valid <== 5;

}

