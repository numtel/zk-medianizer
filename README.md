# Solidity Median Library

Uses [BokkyPooBah's Red-Black Binary Search Tree library](https://github.com/bokkypoobah/BokkyPooBahsRedBlackTreeLibrary) to store a sorted list of counts for each integer.

```solidity
contract MedianLibraryTest {
  using MedianLibrary for MedianLibrary.Data;

  MedianLibrary.Data data;

  // Value must be >0, except if a value is already set,
  // passing value of 0 will unset for that account.
  function set(address account, uint value) public {
    data.set(account, value);
  }

  function median() public view returns (uint) {
    return data.median();
  }
}
```

## Installation

This is a Foundry-based repository. Import this library into your Foundry project using:

```
forge install numtel/solidity-median-library
```

## License

MIT
