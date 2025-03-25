# RISC-V Pipelined Datapath

The RISC-V datapath can be pipelined into five stages:

## Pipeline Stages
1. **Instruction Fetch (IF)**
   - Consists of PC calculations and reading instructions from instruction memory.
2. **Operand Fetch (OF)**
   - Fetches the source registers based on the opcode and generates immediates.
3. **Execute (EX)**
   - Performs ALU operations and branch evaluation.
4. **Memory Access (MA)**
   - Handles load and store instructions involving data memory access.
5. **Write Back (WB)**
   - Writes back results from ALU or load instructions to destination registers.

## Synchronization with Clock
Latches can be inserted between each successive stage to synchronize with the clock, ensuring proper data flow and avoiding inconsistencies.

## Control Signals in Operand Fetch Stage
Control signals are used in the Operand Fetch (OF) stage to determine the necessary operations based on the opcode, including register reads, immediate generation, and forwarding mechanisms.

## Data Flow Without Latches
There are two instances where the data packet travels without passing through latches:
1. If branching occurs, the `zero` signal goes back to the Instruction Fetch (IF) stage from the Execute (EX) stage.
2. Writing back results to the destination register from the Write Back (WB) stage to the Operand Fetch (OF) stage.

## Pipeline Hazards
Complications arise when implementing features to avoid pipeline hazards such as:
- Data Hazards
- Control Hazards
- Structural Hazards

Techniques such as forwarding, stalling, and branch prediction are used to counter these hazards and improve pipeline efficiency.

