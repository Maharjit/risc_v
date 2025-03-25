To add a custom instruction which calculates the number of trailing zeroes(TZ) we can make the 'ALUSrc' control signal 3 bits instead of 2 bits.
We can then add a case for the opcode of the TZ instruction in the control module and generate a unique 'ALUSrc' signal.
In the ALUCtrl unit, we can then again assign a a unique 'ALUCtl' for TZ inst. for subsequent computation in ALU unit.
Then in the ALU unit we can compute "rd = (rs1 == 0) ? 32 : $clog2(rs1 & -rs1)" for the TZ case.
