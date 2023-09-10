# SwapProtocol Smart Contract

The **SwapProtocol** is a simple contract designed to facilitate the exchange of two different ERC-20 tokens, referred to as `tokenA` and `tokenB`. It allows liquidity providers to deposit tokens into the contract and subsequently withdraw them, as well as enabling token swaps between these two tokens.

Swap Contract https://sepolia.etherscan.io/address/0x7c0Ea13D006ccBEc644a16a21995a73c472CE48d

Token A https://sepolia.etherscan.io/address/0xF60ED92Fe334a69E71FDB0dC3b7b6bBC0134AA97

Token B https://sepolia.etherscan.io/address/0x5AB319218641c626c43E687A2FAACad034C35E23

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
