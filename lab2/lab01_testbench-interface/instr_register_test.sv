/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/

//taskul consuma timp de simulare, functia nu
//task nu returneaza valori
// class name
// variabile->seed
// functii->3
// taskuri->run
// interfete->tb_ifc
// endclass:name

import instr_register_pkg::*; 
module instr_register_test(tb_ifc.TEST lab2_if);
include "instr_register_class.svh";

  initial begin
  first_test fs;
  fs=new(lab2_if);
  fs.run();
 
  end  

endmodule: instr_register_test
