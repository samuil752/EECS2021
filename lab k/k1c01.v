/* 
 * Do not change Module name 
 */
module main;
  reg [31:0] instruction;

  initial begin
    // Initial display before any value is assigned to instruction
    $display ("Time: %5d Instruction: Hex: %8h Decimal: %1d Binary: %32b", 
              $time, instruction, instruction, instruction);
    
    // Assign and display instruction with value 10
    #10 instruction = 10;
    $display ("Time: %5d Instruction: Hex: %8h Decimal: %1d Binary: %32b", 
              $time, instruction, instruction, instruction);
    
    // Assign and display instruction with value 20
    #10 instruction = 20;
    $display ("Time: %5d Instruction: Hex: %8h Decimal: %1d Binary: %32b", 
              $time, instruction, instruction, instruction);
    
    // Assign and display instruction with value 30
    #10 instruction = 30;
    $display ("Time: %5d Instruction: Hex: %8h Decimal: %1d Binary: %32b", 
              $time, instruction, instruction, instruction);
    
    // End the simulation
    $finish;
  end 
endmodule
