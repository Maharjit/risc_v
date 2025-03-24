`timescale 1ns / 1ps

`include "ALUCtrl.sv"
`include "ALU.sv"
`include "DataMemory.sv"
`include "Register.sv"
`include "PC.sv"
`include "immGen.sv"
`include "control.sv"
`include "Mux2to1.sv"
`include "Adder.sv"
`include "InstructionMemory.sv"
`include "ShiftLeftOne.sv"


module SingleCycleCPU (
    input clk,
    input start
    
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
reg branch, memRead, memtoReg, memWrite, ALUSrc, regWrite, branch_taken, r_type, zero;
  wire funct7;
  wire [2:0] funct3;
  wire [1:0] ALUOp;
  wire [6:0] opcode;
  wire[31:0] pc_i, inst, writeData, operand_2;
  reg [31:0] pc_o, readData;
  reg signed [31:0] imm, pc_plus_4, branch_target, ALUOut;
  wire signed [31:0] branch_offset, readData1, readData2;
  reg [3:0] ALUCtl; 
  wire [4:0] readReg1, readReg2, writeReg;

PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pc_i),
    .pc_o(pc_o)
);

Adder m_Adder_1(
    .a(pc_o),
    .b(32'd4),
    .sum(pc_plus_4)
);

InstructionMemory m_InstMem(
    .readAddr(pc_o),
    .inst(inst)
);

assign opcode = inst[6:0];
  
control m_control(
  .opcode(opcode),
    .branch(branch),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite)
);

  assign readReg1 = inst[19:15];
  assign readReg2 = inst[24:20];
  assign writeReg = inst[11:7];
Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(readReg1),
  .readReg2(readReg2),
  .writeReg(writeReg),
    .writeData(writeData),
    .readData1(readData1),
    .readData2(readData2)
);


  immGen #(.Width(32)) m_immGen(
    .inst(inst),
    .imm(imm)
);

/*ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(branch_offset)
);
*/

Adder m_Adder_2(
    .a(pc_o),
     .b(imm),
    .sum(branch_target)
);

Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(branch_taken),
    .s0(pc_plus_4),
    .s1(branch_target),
    .out(pc_i)
);

  assign r_type = (opcode == 7'b0110011 || opcode == 7'b1100011) ? 1'b0 : 1'b1; //add,sub,beq,bgt

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(r_type),
    .s0(readData2),
    .s1(imm),
    .out(operand_2)
);

  assign funct7 = inst[30];
  assign funct3 = inst[14:12];
ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(funct7),
    .funct3(funct3),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUCtl(ALUCtl),
    .A(readData1),
    .B(operand_2),
    .ALUOut(ALUOut),
    .zero(zero)
);

assign branch_taken = (branch & zero);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),
    .writeData(readData2),
    .readData(readData)
);

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut),
    .s1(readData),
    .out(writeData)
);



endmodule
