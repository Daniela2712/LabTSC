class first_test;

//***************************************************************************************************
    //tema implementam verificare pentru rezultat, in print result facem functie check results 
    //(daca reultatul in clasa e egal cu cel trimis de dut printal pass else print fail)
    //verificam daca ceck functionea za in ambele cazuti
//******************************************************************************************************

    //int seed = 777;
    virtual tb_ifc.TEST lab2_if;

    int NUMBEROFTRANSACTION;
    int error_counter;
covergroup my_func_coverage;
      coverpoint lab2_if.cb.operand_a {
        bins operand_a_values_pos[]={[1:15]};
        bins operand_a_values_zero={0};
        bins operand_a_values_neg[]={[-15:-1]};
      }
      coverpoint lab2_if.cb.operand_b {
        bins operand_b_values_pos[]={[1:15]};
        bins operand_b_values_zero={0};
      }
      coverpoint lab2_if.cb.opcode {
        bins opcode_values_pos[]={[1:7]};
        bins opcode_values_zero={0};
      }
    endgroup

    function new(virtual tb_ifc.TEST ifc);
      lab2_if=ifc;
      this.error_counter=0;
       my_func_coverage=new();
    endfunction

    
    

     task run();

     if (!$value$plusargs("NUMBEROFTRANSACTION=%0d", NUMBEROFTRANSACTION)) begin
      NUMBEROFTRANSACTION = 5;
     end


      $display("\n\n***********************************************************");
      $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
      $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
      $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
      $display(    "***********************************************************");
      $display(" First display");
      $display("\nReseting the instruction register...");
      
      
      lab2_if.cb.write_pointer <= 5'h00;         // initialize write pointer
      lab2_if.cb.read_pointer  <= 5'h1F;         // initialize read pointer
      lab2_if.cb.load_en       <= 1'b0;          // initialize load control line
      lab2_if.cb.reset_n       <= 1'b0;          // assert reset_n (active low)
      repeat (2) @(lab2_if.cb) ;     // hold in reset for 2 clock cycles
      lab2_if.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

      $display("\nWriting values to register stack...");
      @(lab2_if.cb) lab2_if.cb.load_en <= 1'b1;  // enable writing to register
      repeat (NUMBEROFTRANSACTION) begin
        @(lab2_if.cb) randomize_transaction;
        @(lab2_if.cb) print_transaction;
        my_func_coverage.sample();

      end
      @(lab2_if.cb) lab2_if.cb.load_en <= 1'b0;  // turn-off writing to register

      // read back and display same three register locations
      $display("\nReading back the same register locations written...");

      //  repeat (10) begin
      //   int i;
      //    @(lab2_if.cb) lab2_if.cb.read_pointer <= $random(i)%16;
      //    @(negedge lab2_if.cb) print_results;
      //  end


      for (int i=NUMBEROFTRANSACTION; i>=0; i--) begin
        // later labs will replace this loop with iterating through a
        // scoreboard to determine which addresses were written and
        // the expected values to be read back
        @(lab2_if.cb) lab2_if.cb.read_pointer <= i;
        @(negedge lab2_if.cb) print_results;
        
      end

  //TEMA DE CASA in struct instr_t adaugam semnal de result(cat de de mare), 
  //ii facem display in print_results, ne ducem in dut si declaram un case in fct de operatie(din enum),
  // o sa fie afisat rezultatul fiecarei operatii sub formele de unde

      @(lab2_if.cb) ;
      $display("\n***********************************************************");
      $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
      $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
      $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
      $display(  "***********************************************************\n");
       // Error evaluation
    if (this.error_counter == 0) begin
      $display("TEST PASSED");
    end else if (this.error_counter > 0) begin
      $display("TEST FAILED (%0d errors)", this.error_counter);
    end
      $finish;
    endtask

     function void randomize_transaction;
      // A later lab will replace this function with SystemVerilog
      // constrained random values
      //
      // The stactic temp variable is required in order to write to fixed
      // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
      // write_pointer values in a later lab
      //
      static int temp = 0;
      lab2_if.cb.operand_a     <= ($signed($urandom))%16;                 // between -15 and 15
      lab2_if.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
      lab2_if.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type
      lab2_if.cb.write_pointer <= temp++;
    endfunction: randomize_transaction

    function void print_transaction;
      $display("Writing to register location %0d: ", lab2_if.cb.write_pointer);
      $display("  lab2_if.cb.opcode = %0d (%s)", lab2_if.cb.opcode, lab2_if.cb.opcode.name);
      $display("  lab2_if.cb.operand_a = %0d",   lab2_if.cb.operand_a);
      $display("  lab2_if.cb.operand_b = %0d\n", lab2_if.cb.operand_b);
    endfunction: print_transaction

    function void print_results;
      $display("Read from register location %0d: ", lab2_if.cb.read_pointer);
      $display("  lab2_if.cb.opcode = %0d (%s)", lab2_if.cb.instruction_word.opc, lab2_if.cb.instruction_word.opc.name);
      $display("  lab2_if.cb.operand_a = %0d",   lab2_if.cb.instruction_word.op_a);
      $display("  lab2_if.cb.operand_b = %0d\n", lab2_if.cb.instruction_word.op_b);
      $display("  result    = %0d\n", lab2_if.cb.instruction_word.result);
      case (lab2_if.cb.instruction_word.opc.name)
      "PASSA" : begin
        if (lab2_if.cb.instruction_word.result != lab2_if.cb.instruction_word.op_a) begin
          $error("PASSA operation error: Expected result = %0d Actual result = %0d\n", lab2_if.cb.instruction_word.op_a, lab2_if.cb.instruction_word.result);
          error_counter += 1;
        end
      end
      "PASSB" : begin
        if (lab2_if.cb.instruction_word.result != lab2_if.cb.instruction_word.op_b) begin
          $error("PASSB operation error: Expected result = %0d Actual result = %0d\n", lab2_if.cb.instruction_word.op_b, lab2_if.cb.instruction_word.result);
          error_counter += 1;
        end
      end
      "ADD" : begin
        if (lab2_if.cb.instruction_word.result != $signed(lab2_if.cb.instruction_word.op_a + lab2_if.cb.instruction_word.op_b)) begin
          $error("ADD operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a + lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.result);
          error_counter += 1;
        end
      end
      "SUB" : begin
        if (lab2_if.cb.instruction_word.result != $signed(lab2_if.cb.instruction_word.op_a - lab2_if.cb.instruction_word.op_b)) begin
          $error("SUB operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a - lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.result);
          error_counter += 1;
        end
      end
      "MULT" : begin
        if (lab2_if.cb.instruction_word.result != $signed(lab2_if.cb.instruction_word.op_a * lab2_if.cb.instruction_word.op_b)) begin
          $error("MULT operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a * lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.result);
          error_counter += 1;
        end
      end
      "DIV" : begin
        if (lab2_if.cb.instruction_word.result != $signed(lab2_if.cb.instruction_word.op_a / lab2_if.cb.instruction_word.op_b)) begin
          $error("DIV operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a / lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.result);
          error_counter += 1;
        end
      end
      "MOD" : begin
        if (lab2_if.cb.instruction_word.result != $signed(lab2_if.cb.instruction_word.op_a % lab2_if.cb.instruction_word.op_b)) begin
          $error("MOD operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a % lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.result);
          error_counter += 1;
        end
      end
    endcase 

    endfunction: print_results
  
  endclass