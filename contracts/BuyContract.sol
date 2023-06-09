// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "uniswap-v2-contract/contracts/uniswap-v2-periphery/interfaces/IUniswapV2Router02.sol";
import "uniswap-v2-contract/contracts/uniswap-v2-core/interfaces/IUniswapV2Factory.sol";
import "uniswap-v2-contract/contracts/uniswap-v2-core/interfaces/IUniswapV2Pair.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BuyContract is Ownable {
    // Address of the Uniswap v2 router
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    // Address of WETH token
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    //Address of the fund receiver
    address private platformAddress;

    address private maintanierAddress;

    // constructor(address _platformAddress, address _maintanierAddress) {
    //     platformAddress = _platformAddress;
    //     maintanierAddress = _maintanierAddress;
    // }

    /**
     * Perform a token swap from one token to another
     * @param _tokenIn The address of the token to trade out of
     * @param _tokenOut The address of the token to receive in the trade
     * @param _amountIn The amount of tokens to send in
     * @param _amountOutMin The minimum amount of tokens expected to receive
     * @param _to The address to send the output tokens to
     */
    function swapWithFee(
        address _tokenIn,
        address _tokenOut,
        uint256 _amountIn,
        uint256 _amountOutMin,
        address _to
    ) external {
        // Calculate the percentage to deduct
        uint256 deductionAmount = (_amountIn * 99) / 10000; // 0.99% deduction
        uint256 maintanierFee = deductionAmount / 2;
        uint256 platformFee = deductionAmount - maintanierFee;

        IERC20(maintanierAddress).transferFrom(
            msg.sender,
            address(this),
            maintanierFee
        );
        IERC20(platformAddress).transferFrom(
            msg.sender,
            address(this),
            platformFee
        );

        // Deduct the percentage from the tokenIn amount
        uint256 amountToSwap = _amountIn - deductionAmount;

        // Transfer the amount in tokens from the caller to this contract
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), amountToSwap);

        // Approve the Uniswap router to spend the transferred tokens
        IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER, amountToSwap);

        // Construct the token swap path
        address[] memory path;
        if (_tokenIn == WETH || _tokenOut == WETH) {
            path = new address[](2);
            path[0] = _tokenIn;
            path[1] = _tokenOut;
        } else {
            path = new address[](3);
            path[0] = _tokenIn;
            path[1] = WETH;
            path[2] = _tokenOut;
        }

        // Call the Uniswap router to perform the token swap
        IUniswapV2Router02(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
            amountToSwap,
            _amountOutMin,
            path,
            _to,
            block.timestamp
        );
    }

    /**
     * Get the minimum amount of token Out for a given token In and amount In
     * @param _tokenIn The address of the token to trade out of
     * @param _tokenOut The address of the token to receive in the trade
     * @param _amountIn The amount of tokens to send in
     * @return The minimum amount of tokens expected to receive
     */
    function getAmountOutMin(
        address _tokenIn,
        address _tokenOut,
        uint256 _amountIn
    ) external view returns (uint256) {
        // Construct the token swap path
        address[] memory path;
        if (_tokenIn == WETH || _tokenOut == WETH) {
            path = new address[](2);
            path[0] = _tokenIn;
            path[1] = _tokenOut;
        } else {
            path = new address[](3);
            path[0] = _tokenIn;
            path[1] = WETH;
            path[2] = _tokenOut;
        }

        // Get the minimum amount of token Out
        uint256[] memory amountOutMins = IUniswapV2Router02(UNISWAP_V2_ROUTER)
            .getAmountsOut(_amountIn, path);
        return amountOutMins[path.length - 1];
    }

    function setPlatformAddress(address _account) external onlyOwner {
        platformAddress = _account;
    }

    function setMaintainerAddress(address _account) external onlyOwner {
        maintanierAddress = _account;
    }
}
