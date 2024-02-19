pragma circom 2.1.5;

include "comparators.circom";
include "./CalculateTotal.circom";

template BubbleSort(n) {
  // n is the size of the array to be sorted
  signal input arr[n];
  signal output sortedArr[n];

  component swaps[n*n];
  var buffer[n] = arr;
  var index;

  for (var l = 0; l < n-1; l++) {
    for (var i = 0; i < n-1-l; i++) {
      index = i + (l*n);
      swaps[index] = Swap();
      if (i == 0) {
        swaps[index].in[0] <== buffer[i];
        swaps[index].in[1] <== buffer[i+1];
      } else {
        swaps[index].in[0] <== swaps[index-1].out[1];
        swaps[index].in[1] <== buffer[i+1];
      }
      buffer[i] = swaps[index].out[0];
      buffer[i+1] = swaps[index].out[1];
    }
  }
  sortedArr <== buffer;
}

template Swap() {
  signal input in[2];
  signal output out[2];

  var isGreater = GreaterThan(252)(in);
  var isLess = LessThan(252)(in);

  var num0 = CalculateTotal(2)([
    isGreater * in[1],
    isLess * in[0]
  ]);

  var num1 = CalculateTotal(2)([
    isGreater * in[0],
    isLess * in[1]
  ]);

  out[0] <== num0;
  out[1] <== num1;
}

