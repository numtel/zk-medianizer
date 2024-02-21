pragma circom 2.1.5;

// include "poseidon.circom";
include "comparators.circom";
include "gates.circom";

// Linear time O(n) median verification algorithm
// Author: numtel <ben@latenightsketches.com>
template Median(COUNT, BITS) {
  // values input are double their actual values in order to have full precision
  // in the case of the median being between two subsequent integers
  //  e.g. 3,4 => 3.5 doubled is 6,8 => 4
  signal input values[COUNT];
  signal input doubleMedian;
  signal input nearestUnder;
  signal input nearestOver;
  signal input equalAbove;
  signal input equalBelow;
//   signal output hash;

  var zeroes[COUNT + 1];
  component testZero[COUNT];
  var overs[COUNT + 1];
  component testGreater[COUNT];
  var unders[COUNT + 1];
  component testLess[COUNT];
  var equals[COUNT + 1];
  component testEqual[COUNT];
  var closerOvers[COUNT];
  component testCloserOver[COUNT];
  var closerUnders[COUNT];
  component testCloserUnder[COUNT];

  for(var i=0; i<COUNT; i++) {
    testZero[i] = IsZero();
    testZero[i].in <== values[i];
    zeroes[i + 1] = zeroes[i] + testZero[i].out;

    testGreater[i] = GreaterThan(BITS);
    testGreater[i].in <== [values[i], doubleMedian];
    overs[i + 1] = overs[i] + testGreater[i].out;

    testLess[i] = LessThan(BITS);
    testLess[i].in <== [values[i], doubleMedian];
    unders[i + 1] = unders[i] + testLess[i].out;

    testEqual[i] = IsEqual();
    testEqual[i].in <== [values[i], doubleMedian];
    equals[i + 1] = equals[i] + testEqual[i].out;

    // TODO these won't be valid constraints if summed in place?
    testCloserOver[i] = LessThan(BITS);
    testCloserOver[i].in <== [values[i], nearestOver];
    // TODO needs to also check 
    closerOvers[i] = testCloserOver[i].out * testGreater[i].out; // AND

    testCloserUnder[i] = GreaterThan(BITS);
    testCloserUnder[i].in <== [values[i], nearestUnder];
    closerUnders[i] = testCloserUnder[i].out * testLess[i].out; // AND
  }

  signal totalCloserOver <== CalculateTotal(COUNT)(closerOvers);
  signal totalCloserUnder <== CalculateTotal(COUNT)(closerUnders);
  signal totalOver <== overs[COUNT] + equalAbove;
  signal totalUnder <== unders[COUNT] - zeroes[COUNT] + equalBelow;
  signal totalCount <== overs[COUNT] + unders[COUNT] - zeroes[COUNT] + equals[COUNT];

  signal overEqualsUnder <== IsEqual()([totalOver, totalUnder]);

  signal countIsOdd <== IsOdd(BITS)(totalCount);
  signal atLeast2Equal <== GreaterEqThan(32)([ equals[COUNT], 2 ]);
  signal nearestAvg <== PairAverage()(nearestOver, nearestUnder);
  signal evenBetweener <== IsEqual()([ doubleMedian, nearestAvg ]);
  signal oddOrAtLeast2Equal <== OR()(countIsOdd, atLeast2Equal);
  signal oddOrAtLeast2EqualOrEvenBetweener <== OR()(oddOrAtLeast2Equal, evenBetweener);

  signal inputEqual <== equalAbove + equalBelow + countIsOdd;

  equals[COUNT] === inputEqual;
  totalCloserOver + totalCloserUnder === 0;
  overEqualsUnder === 1;
  oddOrAtLeast2EqualOrEvenBetweener === 1;

  log(
    "\nzero", zeroes[COUNT],
    "\novers", totalOver,
    "\nunders", totalUnder,
    "\nequals", equals[COUNT],
    "\ncount", totalCount,
    "\nisOdd", countIsOdd,
    "\noverEqualsUnder", overEqualsUnder,
    "\natLeast2Equal", atLeast2Equal,
    "\nnearestOver", nearestOver,
    "\nnearestUnder", nearestUnder,
    "\nnearestAvg", nearestAvg,
    "\n\n"
  );

  // TODO use Poseidon(2)([x,y]) to build cumulatively
//   hash <== Poseidon(COUNT)(values);

}

template CalculateTotal(N) {
    signal input in[N];
    signal output out;

    signal outs[N];
    outs[0] <== in[0];

    for (var i=1; i < N; i++) {
        outs[i] <== outs[i - 1] + in[i];
    }

    out <== outs[N - 1];
}

template PairAverage() {
  signal input a;
  signal input b;
  signal output out;

  var sum = a + b;
  out <== sum / 2;
}

template IsOdd(nBits) {
  signal input in;
  signal output out;

  component n2b = Num2Bits(nBits);

  n2b.in <== in;

  out <== n2b.out[0];
}
