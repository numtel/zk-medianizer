# Solidity Median Library

Uses [BokkyPooBah's Red-Black Binary Search Tree library](https://github.com/bokkypoobah/BokkyPooBahsRedBlackTreeLibrary) to store a sorted list of counts for each integer.

```solidity
import "solidity-median-library/MedianLibrary.sol";

contract MedianLibraryTest {
  using MedianLibrary for MedianLibrary.Data;

  MedianLibrary.Data data;

  // Value must be >0, except if a value is already set,
  // passing value of 0 will unset for that id.
  function set(uint256 id, uint value) public {
    data.set(id, value);
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
