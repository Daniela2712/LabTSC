/***********************************************************************
 * A SystemVerilog testbench for an instruction register; This file
 * contains the interface to connect the testbench to the design
 **********************************************************************/
interface tb_ifc (input logic clk);
 // timeunit 1ns/1ns;
 wire [7:0] data;
 clocking cb @(posedge clk);
    inout load_en;
    inout reset_n;
    inout opcode;
    inout operand_a;
    inout operand_b;
    inout write_pointer;
    inout read_pointer;
    inout instruction_word;
 endclocking;
 modport  Test (clocking cb); 
 

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;
 logic          load_en;
 logic          reset_n;
 opcode_t       opcode;
 operand_t      operand_a, operand_b;
 address_t      write_pointer, read_pointer;
 instruction_t  instruction_word;

  // ADD CODE TO DECLARE THE INTERFACE SIGNALS


endinterface: tb_ifc

