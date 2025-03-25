The RISC-V datapath can be pipelined into 5 stages:
> Instruction Fetch ( consisting pc calculations and reading instructions from inst. memory)(IF)
> Operand Fetch ( Fetching the source registers based on the opcode and generating immediates)(OF)
> Execute (ALU+branch unit)(EX)
> Memory Access( load,store instructions involving data memory access)(MA)
> Write Back ( writing back to registers the load/ALU results)(WB)

We can insert latches between each of the successive stages to to synchronise with the clock.

Control signals in the operand fetch stage.

There are 2 instances where the data packet travels without going through the latches
> If branching occurs then the 'zero' signal goes back to the IF stage from Execute Stage.
> Writing back results to destination register from WB stage to OF stage.

Complications arise when we have to create features to avoid pipeline hazards.

