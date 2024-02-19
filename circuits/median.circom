pragma circom 2.1.5;

// include "poseidon.circom";
include "./AtIndex.circom";
include "./BubbleSort.circom";

template Median(MAX_COUNT) {
  signal input values[MAX_COUNT];
  signal input actualSize;
  signal output median;

  assert(actualSize <= MAX_COUNT && actualSize >= 1);
  assert(actualSize % 2 == 1);

  var sorted[MAX_COUNT] = BubbleSort(MAX_COUNT)(values);

  var buffer = 0;
  var missing = MAX_COUNT - actualSize;
  buffer = AtIndex(MAX_COUNT)(sorted, (actualSize-1)/2 + missing);
  median <== buffer;
}
