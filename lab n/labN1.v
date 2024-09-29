
module labN;
wire zero;
reg RegWrite, clk, ALUSrc, MemRead, MemWrite, Mem2Reg, INT, isbranch, isjump;
reg [2:0] op;
reg [31:0] entryPoint;
wire [31:0] wd, rd1, rd2, imm, ins, PCp4, z, branchImm, memOut, PCin, PC, wb, jImm;

yIF myIF (ins, PC, PCp4, PCin, clk); //Inputs: PCin, clk. Outputs: ins, PCp4.
yID myID (rd1, rd2, imm, jImm, branchImm, ins, wd, RegWrite, clk); //Inputs: ins, wd, RegWrite, clk. Outputs: rd1, rd2, imm, jTarget, branch.
yEX myEx (z, zero, rd1, rd2, imm, op, ALUSrc); //Inputs:  rd1, rd2, imm, op, ALUSrc. Outputs: z, zero.
yDM myDM (memOut, z, rd2, clk, MemRead, MemWrite);
yWB myWB (wb, z, memOut, Mem2Reg);
yPC myPC (PCin, PC, PCp4, INT, entryPoint, branchImm, jImm, zero, isbranch, isjump);

assign wd = wb;

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
        //temporary
        isjump = 0;
        isbranch = 0;
        RegWrite = 0;
        ALUSrc = 1; //imm
        op = 3'b010; //add
        MemRead = 0;
        MemWrite = 0;
        Mem2Reg = 0; //load
        //----------set control signals
        //R-type: 0110011
        if (ins[6:0] == 7'h33) begin
            ALUSrc = 0;
            if (ins[31:25] == 7'h00/*funct7*/&& ins[14:12]== 3'h0/*funct3*/)
                op = 3'b010; //add, or
            if (ins[31:25] == 7'h20/*funct7*/&& ins[14:12]== 3'h0/*funct3*/)
                op = 3'b110; //sub
            if (ins[31:25] == 7'h00/*funct7*/&& ins[14:12]== 3'h2/*funct3*/)
                op = 3'b011; //slt
        end
        //For S-Type: 0100011
        if (ins[6:0]== 7'h23) begin
            ALUSrc = 1;
            op = 3'b010; //sw
        end
        //For I-Type: 0000011
        if (ins[6:0] == 7'h3 || ins[6:0] == 7'h13) begin
            ALUSrc = 1;
            op = 3'b010; //lw, addi
        end
        //And for SB-Type: 1100011
        if (ins[6:0] == 7'h63) begin
            ALUSrc = 0;
            op = 3'b110; //branch
            #1;
            isbranch = 1;
        end
        //the UJ-type: 1101111
        if (ins[6:0] == 7'h6F) begin
            isjump = 1;
        end
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
