module ALU (
    input [3:0] ALUCtl,
    input signed [31:0] A,B,
    output reg signed [31:0] ALUOut,
    output reg zero
);
    // ALU has two operand, it execute different operator based on ALUctl wire 
    // output zero is for determining taking branch or not 

    // TODO: implement your ALU here
    // Hint: you can use operator to implement
    always @(*) begin 
      case(ALUCtl) 
        4'b0000: ALUOut = A + B; // add,addi,lw,sw
        4'b0001: ALUOut = A - B; // sub
        4'b0010: ALUOut = A | B;
        4'b0011: ALUOut = (A<B)? 1 : 0;
        default: ALUOut = A + B; 
      endcase
      case(ALUCtl)
        4'b0100: zero = (A==B)? 1 : 0;
        4'b0101: zero = (A>B)? 1 : 0; 
        default: zero = 1; // jal
      endcase
    end
    
endmodule
