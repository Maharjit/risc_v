module ALUCtrl (
    input [2:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

    // TODO: implement your ALU ALUCtl here
   // Hint: using ALUOp, funct7, funct3 to select exact operation
   wire [6:0] ALUControlIn;  
   assign ALUControlIn = {ALUOp,funct3,funct7};
   always @(*) begin
     casez(ALUControlIn) 
       7'b0000000 : ALUCtl = 4'b0000; //add
       7'b0000001 : ALUCtl = 4'b0001; //sub
       7'b1000101 : ALUCtl = 4'b0110; //tz 
       7'b001000? : ALUCtl = 4'b0000; //addi
       7'b001110? : ALUCtl = 4'b0010; //ori
       7'b001010? : ALUCtl = 4'b0011; //slti
       7'b011000? : ALUCtl = 4'b0100; //beq
       7'b011101? : ALUCtl = 4'b0101; //bgt
       7'b010010? : ALUCtl = 4'b0000; //lw,sw
       default : ALUCtl = 4'b0000;
     endcase
   end
endmodule
