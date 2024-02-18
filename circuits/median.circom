pragma circom 2.1.5;

// include "poseidon.circom";
include "./AtIndex.circom";

template Median(MAX_COUNT) {
  signal input values[MAX_COUNT];
  signal input actualSize;
  signal output median;

  assert(actualSize <= MAX_COUNT && actualSize >= 1);
  assert(actualSize % 2 == 1);

  var buffer = 0;
  buffer = AtIndex(MAX_COUNT)(values, (actualSize-1)/2);
  median <== buffer;
}

