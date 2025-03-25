# Final Value of Register x2

## Given Initial Values:
- `x1 = 8`
- `x2 = 2`

## Execution Analysis:
### Loop Behavior:
- `slt x2, x0, x1`: Sets `x2 = 1` while `x1 > 0`.
- `beq x2, x0, DONE`: Exits when `x2 = 0` (i.e., `x1 = 0`).
- `addi x1, x1, -1`: Decrements `x1`.
- `addi x2, x2, 2`: Increments `x2` by 2 .

### Iteration Count:
- Loop runs **8 times** until `x1 = 0`.
- `x2` resets to 1 at each entry into the loop except when `x1 = 0`.
- `x2` = 0 ( finally)
- exits the loop since `x2` == 0

