// Linear time O(n) median verification algorithm
// Author: numtel <ben@latenightsketches.com>
// License: MIT
export default function verifyMedian(values, newMedian) {
  let countZero = 0;
  let countUnder = 0;
  let countEqual = 0;
  let countOver = 0;
  let nearestUnder = 0;
  let nearestOver = Number.MAX_SAFE_INTEGER;

  for(let i = 0; i < values.length; i++) {
    if(values[i] === 0) {
      countZero++;
    } else if (values[i] > newMedian) {
      countOver++;
      if(values[i] < nearestOver) {
        nearestOver = values[i];
      }
    } else if (values[i] < newMedian) {
      countUnder++;
      if(values[i] > nearestUnder) {
        nearestUnder = values[i];
      }
    } else if (values[i] === newMedian) {
      countEqual++;
    }
  }

  // Balance out duplicates of the median
  while(countEqual > 1 && countOver !== countUnder) {
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

  const countIsOdd = (values.length - countZero) % 2 === 1;
  return (countUnder === countOver) &&
    (countIsOdd
      || countEqual >= 2
      || newMedian === (nearestOver + nearestUnder) / 2);
}

function testMedian(values, median) {
  if(!verifyMedian(values, median))
    throw new Error(JSON.stringify(values) + ', expected: ' + median);
  for(let item of values) {
    const isMedian = verifyMedian(values, item);
    if(item === median ? !isMedian : isMedian)
      throw new Error(JSON.stringify(values) + ', unexpected: ' + item);
  }
}

testMedian([0,0,1,2,3,3,5], 3);
testMedian([0,1,2,3,3,5], 3);
testMedian([1,2,3,3,5], 3);
testMedian([1,2,3,3,3], 3);
testMedian([1,2,3,3,3,5,6], 3);
testMedian([1,2,3,3,5,6], 3);
testMedian([1,2,3,3,6,6], 3);
testMedian([1,2,3,3,5,6,7], 3);
testMedian([1,3,3,5,6,7], 4);
testMedian([1,2,3,3,3,3,5,6,7], 3);
testMedian([7,6,3,3,3,3,5,1,2], 3);

