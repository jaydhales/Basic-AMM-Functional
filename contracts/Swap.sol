// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract SwapProtocol {
    address tokenA;
    address tokenB;

    struct LiquidityProvider {
        uint AmountA;
        uint AmountB;
    }

    mapping(address => LiquidityProvider) public liquidityProvider;

    error WrongTokenAddr(address addr);

    constructor(address _tokenA, address _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function addLiquidity(uint _amountA, uint _amountB) external {
        IERC20(tokenA).transferFrom(msg.sender, address(this), _amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), _amountB);

        LiquidityProvider storage provider = liquidityProvider[msg.sender];

        provider.AmountA += _amountA;
        provider.AmountB += _amountB;
    }

    function removeLiquidity(uint _amountA, uint _amountB) external {
        LiquidityProvider storage provider = liquidityProvider[msg.sender];
        require(
            provider.AmountA >= _amountA,
            "Insufficient ammount of A in Liquidity Pool"
        );
        require(
            provider.AmountB >= _amountB,
            "Insufficient ammount of B in Liquidity Pool"
        );

        provider.AmountA -= _amountA;
        provider.AmountB -= _amountB;

        bool successA = IERC20(tokenA).transfer(msg.sender, _amountA);
        require(successA, "Failed to remove liquidity");

        bool successB = IERC20(tokenB).transfer(msg.sender, _amountB);
        require(successB, "Failed to remove liquidity");
    }

    function swap(address _addr, uint _amountIn) public {
        uint valueOut = _calculateAmmountToSwap(_addr, _amountIn);
        if (_addr == tokenA) {
            _swap(tokenA, _amountIn, tokenB, valueOut);
        } else if (_addr == tokenB) {
            _swap(tokenB, _amountIn, tokenA, valueOut);
        } else {
            revert WrongTokenAddr(_addr);
        }
    }

    function getReserve() public view returns (uint _reserveA, uint _reserveB) {
        _reserveA = IERC20(tokenA).balanceOf(address(this));
        _reserveB = IERC20(tokenB).balanceOf(address(this));
    }

    function _swap(
        address _addrIn,
        uint _valueIn,
        address _addrOut,
        uint _valueOut
    ) internal {
        bool successIn = IERC20(_addrIn).transferFrom(
            msg.sender,
            address(this),
            _valueIn
        );
        require(successIn, "Failed to Swap");

        bool successOut = IERC20(_addrOut).transfer(msg.sender, _valueOut);
        require(successOut, "Failed to Swap");
    }

    function _calculateAmmountToSwap(
        address _tokenAddr,
        uint _amountIn
    ) internal view returns (uint valueOut) {
        uint _reserveA = IERC20(tokenA).balanceOf(address(this));
        uint _reserveB = IERC20(tokenB).balanceOf(address(this));

        uint k = _getConstant(_reserveA, _reserveB);

        if (_tokenAddr == tokenA) {
            // Calculation for value of B (B- (k/ A+a))
            valueOut = _calculate(k, _amountIn, _reserveA, _reserveB);
        } else if (_tokenAddr == tokenB) {
            // Calculation for value of A (A- (k/ B+b))
            valueOut = _calculate(k, _amountIn, _reserveB, _reserveA);
        } else {
            revert WrongTokenAddr(_tokenAddr);
        }
    }

    function _getConstant(
        uint _reserveA,
        uint _reserveB
    ) internal pure returns (uint k) {
        k = _reserveA * _reserveB;
    }

    function _calculate(
        uint _k,
        uint _x,
        uint _RX,
        uint _RY
    ) internal pure returns (uint _y) {
        uint _tX = _RX + _x;
        _y = _RY - (_k / _tX);
    }
}
