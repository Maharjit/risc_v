module control (
    input [6:0] opcode,
    output  reg branch,
    output  reg memRead,
    output  reg memtoReg,
    output  reg [2:0] ALUOp,
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
            ALUOp = 2'b000;
            branch = 1'b0;   
        end
        7'b0110011: begin //tz
            ALUSrc = 1'b0;
            memtoReg = 1'b0;
            regWrite = 1'b1;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b100;
            branch = 1'b0;
        end
        7'b0010011:  begin //addi,ori,slti
            ALUSrc = 1'b1;
            memtoReg = 1'b0;
            regWrite = 1'b1;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b001;
            branch = 1'b0;   
        end
        7'b0000011:  begin //ld
            ALUSrc = 1'b1;
            memtoReg = 1'b1;
            regWrite = 1'b1;
            memRead = 1'b1;
            memWrite = 1'b0;
            ALUOp = 2'b010;
            branch = 1'b0;   
        end
        7'b0100011:  begin //st
            ALUSrc = 1'b1;
            memtoReg = 1'b0;
            regWrite = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b1;
            ALUOp = 2'b010;
            branch = 1'b0;   
        end
        7'b1100011:  begin  //beq,bgt
            ALUSrc = 1'b0;
            memtoReg = 1'b0;
            regWrite = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b0;
            ALUOp = 2'b011;
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
