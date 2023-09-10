# SwapProtocol Smart Contract

The **SwapProtocol** is a simple contract designed to facilitate the exchange of two different ERC-20 tokens, referred to as `tokenA` and `tokenB`. It allows liquidity providers to deposit tokens into the contract and subsequently withdraw them, as well as enabling token swaps between these two tokens.

## Contract Structure

- The contract stores information about liquidity providers in a mapping, associating each provider's address with the amounts of `tokenA` and `tokenB` they have provided.

- Liquidity providers can add and remove liquidity using the `addLiquidity` and `removeLiquidity` functions, respectively.

- Token swaps are initiated through the `swap` function, which calculates the expected output amount based on the provided input and the current reserves.

- The `getReserve` function allows users to check the current reserve balances of `tokenA` and `tokenB` in the contract.


## Swap Calculation

The token swap calculations in the `SwapProtocol` contract are performed using the constant product formula:

```
x * y = k
```

Here's how the contract calculates the amount to be received (`valueOut`) based on the input amount and current reserve balances for `tokenA` and `tokenB`:

1. **Swap from `tokenA` to `tokenB` (valueOut calculation):**

   ```
   valueOut = k / (_reserveA + _amountIn) - _reserveB
   ```

   - `_reserveA`: Current reserve balance of `tokenA`.
   - `_amountIn`: Amount of `tokenA` provided by the user for the swap.
   - `_reserveB`: Current reserve balance of `tokenB`.
   - `k`: Constant product of the reserve balances.

2. **`Vice Versa for` Swap from `tokenA` to `tokenB` (valueOut calculation)**

These formulas ensure that the product of reserve balances (`x * y`) remains constant before and after the swap, while `valueOut` represents the amount of the other token that the user will receive based on the provided input amount, thus maintaining liquidity in the pool.

## License

This Smart Contract is provided under the SPDX-License-Identifier: SEE LICENSE IN LICENSE. Please refer to the specific license file for details.

**Note:** Make sure to include detailed instructions and precautions for deploying and interacting with the contract when sharing this Readme with users or developers.
