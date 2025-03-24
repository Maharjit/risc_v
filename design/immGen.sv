module immGen#(parameter Width = 32) (
    input [Width-1:0] inst,
    output reg signed [Width-1:0] imm
);
    // ImmGen generate imm value based on opcode

    wire [6:0] opcode = inst[6:0];
    always @(*) 
    begin
        case(opcode)
        7'b0110011:  begin //add,sub
            imm = 32'b0;   
        end
        7'b0010011:  begin //addi,ori,slti
          imm = {{21{inst[31]}},inst[30:20]};   
        end
        7'b0000011:  begin //lw
          imm = {{21{inst[31]}},inst[30:20]};   
        end
        7'b0100011:  begin //sw
          imm = {{21{inst[31]}},inst[30:25],inst[11:7]};   
        end
        7'b1100011:  begin  //beq,bgt
          imm = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};   
        end
        7'b1101111:  begin  //jal
          imm = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};   
        end
        endcase
        
            
            // TODO: implement your ImmGen here
            // Hint: follow the RV32I opcode map table to set imm value

	end
            
endmodule
