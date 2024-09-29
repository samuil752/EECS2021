
module labN;
wire [31:0] ins, rd2, wb;
reg [31:0] entryPoint; 
reg INT, clk;
wire [31:0] wd, rd1, imm, PCp4, z, branchImm, memOut, PCin, PC, jImm;
wire [6:0] opCode;
wire [2:0] funct3, op;
wire [1:0] ALUop;
wire zero, isbranch, isjump, isStype, isItype, isRtype, isLw, RegWrite,ALUSrc, MemRead, MemWrite, Mem2Reg;
yIF myIF (ins, PC, PCp4, PCin, clk); //Inputs: PCin, clk. Outputs: ins, PCp4.
yID myID (rd1, rd2, imm, jImm, branchImm, ins, wd, RegWrite, clk); //Inputs: ins, wd, RegWrite, clk. Outputs: rd1, rd2, imm, jTarget, branch.
yEX myEx (z, zero, rd1, rd2, imm, op, ALUSrc); //Inputs:  rd1, rd2, imm, op, ALUSrc. Outputs: z, zero.
yDM myDM (memOut, z, rd2, clk, MemRead, MemWrite);
yWB myWB (wb, z, memOut, Mem2Reg);
assign wd = wb;
yPC myPC (PCin, PC, PCp4, INT, entryPoint, branchImm, jImm, zero, isbranch, isjump);
assign opCode = ins[6:0];
yC1 controlUnit (isStype, isRtype, isItype, isLw, isjump, isbranch, opCode);
yC2 controlUnit2 (RegWrite, ALUSrc, MemRead, MemWrite, Mem2Reg, isStype, isRtype, isItype, isLw, isjump, isbranch);
yC3 controlUnit3 (ALUop, isRtype, isbranch);
assign funct3 = ins[14:12];
yC4 alucontrolUnit4 (op, ALUop, funct3);

initial
begin
    /*
    fetch(clk yes)-->decode(clk no)-->execute(clk no)-->[ dataMemory(clk yes)-->writeBack(clk no) or writeBack(clk no) ], PC(clk no).
    */
    //-----Entry point
    entryPoint = 32'h28; INT = 1; #1; //wait to get PCin = 32'h28.
    //------Run program 
    repeat (43)
    begin
        //-----Fetch an ins
        clk =1; #1; //wait until instruction is fetched
        INT = 0;
        //----------set control signals only op signal do nothing!
        //-------execute the ins
        clk = 0;
        #2; //wait for z/wd and decode
        //-------view results
        $display("%h: rd1:%2d rd2:%2d exeOut:%3d zero:%b wb:%2d", ins, rd1, rd2, z, zero, wb);
        //-------prepare for the next instruction do nothing!
    end
    $finish;
end
endmodule
