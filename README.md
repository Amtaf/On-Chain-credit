# On_Chain Credit Market

A protocol where users borrow tokens by locking Uniswap LP tokens as collateral.

## Main Features 

### Colateralization

Users deposit Uniswap LP tokens (representing liquidity in pools) as collateral.
Use IERC20 to interact with LP tokens.

### Borrowing

The protocol calculates borrowing power based on LP token value.
Protect against impermanent loss by factoring token volatility.

### Interest calculation

Borrowed tokens accrue interest

### Liquidity provision

If the loan becomes undercollateralized, liquidators can repay the loan and claim collateral.