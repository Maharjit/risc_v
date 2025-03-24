module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

    // TODO: implement your ALU ALUCtl here
   // Hint: using ALUOp, funct7, funct3 to select exact operation
   wire [5:0] ALUControlIn;  
   assign ALUControlIn = {ALUOp,funct3,funct7};
   always @(*) begin
     casez(ALUControlIn) 
       6'b000000 : ALUCtl = 4'b0000; //add
       6'b000001 : ALUCtl = 4'b0001; //sub
       6'b01000? : ALUCtl = 4'b0000; //addi
       6'b01110? : ALUCtl = 4'b0010; //ori
       6'b01010? : ALUCtl = 4'b0011; //slti
       6'b11000? : ALUCtl = 4'b0100; //beq
       6'b11101? : ALUCtl = 4'b0101; //bgt
       6'b10010? : ALUCtl = 4'b0000; //lw,sw
       default : ALUCtl = 4'b0000;
     endcase
   end
endmodule
