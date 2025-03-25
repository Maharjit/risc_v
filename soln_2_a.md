a)  beq
      ALUSrc = 1'b0;
      memtoReg = 1'b0;
      regWrite = 1'b0;
      memRead = 1'b0;
      memWrite = 1'b0;
      ALUOp = 2'b11; //based on my design
      branch = 1'b1; 

      
    sw
      ALUSrc = 1'b1; 
      memtoReg = 1'b0;
      regWrite = 1'b0;
      memRead = 1'b0;
      memWrite = 1'b1;
      ALUOp = 2'b10; //based on my design
      branch = 1'b0;

   lw
    ALUSrc = 1'b1;
    memtoReg = 1'b1;
    regWrite = 1'b1;
    memRead = 1'b1;
    memWrite = 1'b0;
    ALUOp = 2'b10;
    branch = 1'b0; 

