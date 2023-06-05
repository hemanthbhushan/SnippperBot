# BuyContract

The `BuyContract` is a Solidity smart contract that allows users to perform token swaps on the Uniswap v2 decentralized exchange.

# Functions

# `swap`

This function performs a token swap from one token to another.

function swap(
    address _tokenIn,
    address _tokenOut,
    uint256 _amountIn,
    uint256 _amountOutMin,
    address _to
) external


- `_tokenIn`: The address of the token to trade out of.
- `_tokenOut`: The address of the token to receive in the trade.
- `_amountIn`: The amount of tokens to send in.
- `_amountOutMin`: The minimum amount of tokens expected to receive.
- `_to`: The address to send the output tokens to.

# `getAmountOutMin`

This function calculates the minimum amount of `_tokenOut` tokens that will be received for a given input amount of `_tokenIn` tokens.


function getAmountOutMin(
    address _tokenIn,
    address _tokenOut,
    uint256 _amountIn
) external view returns (uint256)


- `_tokenIn`: The address of the token to trade out of.
- `_tokenOut`: The address of the token to receive in the trade.
- `_amountIn`: The amount of tokens to send in.

# Dependencies

The `BuyContract` relies on the following external Solidity contracts:

- `IUniswapV2Router02`: Interface for the Uniswap v2 router contract, allowing token swaps and retrieval of token amounts.
- `IUniswapV2Factory`: Interface for the Uniswap v2 factory contract, allowing retrieval of the pair address for two tokens.
- `IUniswapV2Pair`: Interface for Uniswap v2 pairs contract, allowing retrieval of the token reserves and other pair information.
- `IERC20`: Interface for ERC20 tokens, allowing token transfers and approvals.

Please ensure that the required contract dependencies (`IUniswapV2Router02`, `IUniswapV2Factory`, `IUniswapV2Pair`, and `IERC20`) are deployed and available at the specified addresses before deploying and interacting with the `BuyContract`.