module control (
    input [6:0] opcode,
    output  reg branch,
    output  reg memRead,
    output  reg memtoReg,
    output  reg [1:0] ALUOp,
    output  reg memWrite,
    output  reg ALUSrc,
    output  reg regWrite,
    );

    always @(*) begin
        case(opcode)
        7'b0110011:  begin //add,sub
            ALUSrc = 1'b0;
            memtoReg = 1'b0;
            regWrite = 1'b1;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b00;
            branch = 1'b0;   
        end
        7'b0010011:  begin //addi,ori,slti
            ALUSrc = 1'b0;
            memtoReg = 1'b0;
            regWrite = 1'b1;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b01;
            branch = 1'b0;   
        end
        7'b0000011:  begin //ld
            ALUSrc = 1'b1;
            memtoReg = 1'b1;
            regWrite = 1'b1;
            memRead = 1'b1;
            memWrite = 1'b0;
            ALUOp = 2'b10;
            branch = 1'b0;   
        end
        7'b0100011:  begin //st
            ALUSrc = 1'b1;
            memtoReg = 1'b0;
            regWrite = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b1;
            ALUOp = 2'b10;
            branch = 1'b0;   
        end
        7'b1100011:  begin  //beq,bgt
            ALUSrc = 1'b0;
            memtoReg = 1'b0;
            regWrite = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b11;
            branch = 1'b1;   
        end
        7'b1101111:  begin  //jal
            ALUSrc = 1'b1;
            memtoReg = 1'b0;
            regWrite = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'bxx;
            branch = 1'b1;   
        end
        endcase
    end

endmodule
