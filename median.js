import assert from 'assert';

// Linear time O(n) median verification algorithm
// Author: numtel <ben@latenightsketches.com>
// License: MIT
function verifyMedian(arr, givenMedian) {
  let lessThan = 0;
  let equalTo = 0;
  let greaterThan = 0;
  let nearestUnder = 0;
  let nearestOver = Number.MAX_SAFE_INTEGER;

  // Loop through the array once
  arr.forEach(num => {
    if(num === 0) {
      // noop
    } else if (num < givenMedian) {
      lessThan++;
      if(num > nearestUnder) {
        nearestUnder = num;
      }
    } else if (num > givenMedian) {
      greaterThan++;
      if(num < nearestOver) {
        nearestOver = num;
      }
    } else if (num === givenMedian) {
      equalTo++;
    } else {
      throw new Error('UNEXPECTED');
    }
  });

  if ((arr.length % 2) === 1) {
    if(equalTo >= 1 && lessThan === greaterThan) return true;
    else if(equalTo > 1) {
      while(equalTo > 1) {
        if(lessThan < greaterThan) {
          lessThan++;
          equalTo--;
        } else if(lessThan > greaterThan) {
          greaterThan++;
          equalTo--;
        } else {
          return true;
        }
      }
      return lessThan === greaterThan;
    } else return false;
    return equalTo >= 1 && lessThan === greaterThan;
  } else {
    if(equalTo >= 1 && greaterThan === lessThan) return true;
    else if(equalTo > 1) {
      while(equalTo > 1) {
        if(lessThan < greaterThan) {
          nearestUnder = givenMedian;
          lessThan++;
          equalTo--;
        } else if(lessThan > greaterThan) {
          nearestOver = givenMedian;
          greaterThan++;
          equalTo--;
        } else {
          return true;
        }
      }
      return lessThan === greaterThan;
    } else {
      return (lessThan === greaterThan) && (givenMedian === (nearestOver + nearestUnder) / 2);
    }
  }
}

function testMedian(arr, median) {
  assert.ok(verifyMedian(arr, median), JSON.stringify(arr) + ', expected: ' + median);
  for(let item of arr) {
    const isMedian = verifyMedian(arr, item);
    assert.ok(item === median ? isMedian : !isMedian, JSON.stringify(arr) + ', unexpected: ' + item);
  }
}

testMedian([0,0,1,2,3,3,5], 3);
testMedian([1,2,3,3,5], 3);
testMedian([1,2,3,3,3], 3);
testMedian([1,2,3,3,3,5,6], 3);
testMedian([1,2,3,3,5,6], 3);
testMedian([1,2,3,3,5,6,7], 3);
testMedian([1,3,3,5,6,7], 4);
testMedian([1,2,3,3,3,3,5,6,7], 3);
testMedian([7,6,3,3,3,3,5,1,2], 3);

