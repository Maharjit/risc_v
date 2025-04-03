# Wishbone
Wishbone uses a **master-slave** setup where the master starts a transaction, and the slave responds.

## Master Initiates:
- Sets `cyc = 1` and `stb = 1` to start the transaction.
- Puts the address (`adr`) on the bus.
- If writing (`we = 1`), sends data (`dat_o`).

## Slave Responds:
- If ready, sets `ack = 1` to confirm completion.
- If reading (`we = 0`), provides data (`dat_i`).

## Transaction Completes:
- Master sees `ack = 1`, then lowers `stb` and `cyc`.
- The bus is now free for the next operation.

---

# AXI 
AXI, designed by **ARM**, follows a **master-slave** model but improves performance by using separate **read and write channels**, enabling simultaneous operations.

## Key Signals in AXI:
- **`valid`** (Master → Slave): Indicates that data or an address is ready to be transferred.
- **`ready`** (Slave → Master): Shows that the slave is ready to accept data. A transfer happens when both `valid` and `ready` are high.
- **`last`** (Master → Slave): Marks the final beat of a burst transfer, signaling the end of a multi-cycle transaction.

---

# CHI 
CHI is a **high-performance** protocol used to keep **data consistent** across multiple processor cores. It helps different cores communicate efficiently with memory without conflicts.

## Key Features:
- **Cache Coherency (CoEsi):** Ensures all cores always see the latest data, avoiding mismatches.
- **Snoopy Filter:** Reduces unnecessary data checks, saving memory bandwidth and power.
