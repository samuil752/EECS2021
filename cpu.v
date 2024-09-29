//cpu.


module yChip (ins, rd2, wb, entryPoint, INT, clk);
    output [31:0] ins, rd2, wb;
    input [31:0] entryPoint; 
    input INT, clk;
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
endmodule
module yC4 (op, ALUop, f);
    output [2:0] op;
    input [2:0] f;
    input [1:0] ALUop;
    // instantiate and connect
    wire t1, t2, t3, notaluop1, notf1;
    or(t1,f[2], f[1]);
    or(t2,f[1], f[0]);
    and(t3,t1, ALUop[1]);
    and(op[0],t2, ALUop[1]);
    or(op[2], t3, ALUop[0]);
    not(notf1, f[1]);
    not(notaluop1, ALUop[1]);
    or(op[1], notf1, notaluop1);
endmodule
module yC3 (ALUop, isRtype, isbranch);
    output [1:0] ALUop; input isRtype, isbranch;
    // build the circuit
    // Hint: you can do it in only 2 lines 
    assign ALUop[1] = isRtype;
    assign ALUop[0] = isbranch;
endmodule
module yC2 (RegWrite, ALUSrc, MemRead, MemWrite, Mem2Reg, isStype, isRtype, isItype, isLw, isjump, isbranch);
    output RegWrite, ALUSrc, MemRead, MemWrite, Mem2Reg;
    input isStype, isRtype, isItype, isLw, isjump, isbranch;
    // You need two or gates and 3 assignments;
    or(ALUSrc, isStype, isItype, isLw);
    or(RegWrite, isRtype, isItype);
    assign MemRead = isLw;
    assign MemWrite = isStype;
    assign Mem2Reg = isLw;
endmodule
module yC1 (isStype, isRtype, isItype, isLw, isjump, isbranch, opCode); 
    output isStype, isRtype, isItype, isLw, isjump, isbranch;
    input [6:0] opCode;
    wire lwor, ISselect, JBselect, sbz, sz;
    // opCode
    // Նա 0000011
    // I-Type 0010011
    // R-Type 0110011
    // SB-Type 1100011
    // UJ-Type 1101111
    // S-Type 0100011

    // Detect UJ-type
    assign isjump=opCode[2];

    // Detect lw
    or (lwor, opCode[6], opCode[5], opCode[4], opCode[3], opCode[2]); 
    not (isLw, lwor);

    // Select between S-Type and I-Type
    xor (ISselect, opCode [6], opCode [5], opCode [4], opCode [3], opCode [2]);
    and (isStype, ISselect, opCode [5]);
    and (isItype, ISselect, opCode [4]);

    // Detect R-Type
    and (isRtype, opCode [5], opCode [4]);

    // Select between JAL and Branch 
    and (JBselect, opCode [6], opCode [5]); 
    not (sbz, opCode [3]);
    and (isbranch, JBselect, sbz); 
endmodule
module yPC (PCin, PC, PCp4, INT, entryPoint, branchImm, jImm, zero, isbranch, isjump); 
    output [31:0] PCin;
    input [31:0] PC, PCp4, entryPoint, branchImm;
    input [31:0] jImm;
    wire [31:0] branchImmX4, jImmX4, jImmX4PPCp4, bTarget, choiceA, choiceB; 
    input INT, zero, isbranch, isjump;
    wire doBranch, zf;
    // Shifting left branchImm twice
    assign branchImmX4[31:2] = branchImm[29:0];
    assign branchImmX4[1:0] = 2'b00;
    // Shifting left jump twice
    assign jImmX4 [31:2] = jImm[29:0];
    assign jImmX4[1:0] =  2'b00;
    //adding PC to shifted twice,
    yAlu bALU(bTarget, zf, PC, branchImmX4, 3'b010);
    yAlu jALU(jImmX4PPCp4, zf, PC, jImmX4, 3'b010);
    //deciding to do branch
    and (doBranch, isbranch, zero);
    yMux #(32) mux1 (choiceA, PCp4, bTarget, doBranch);
    yMux #(32) mux2 (choiceB, choiceA, jImmX4PPCp4, isjump); 
    yMux #(32) mux3 (PCin, choiceB, entryPoint, INT); 
endmodule
module yDM (memOut, exeOut, rd2, clk, MemRead, MemWrite); 
    output [31:0] memOut;
    input [31:0] exeOut, rd2;
    input clk, MemRead, MemWrite;
    // instantiate the circuit (only one line)
    mem writeRead(memOut, exeOut, rd2, clk, MemRead, MemWrite);
endmodule
module yWB (wb, exeOut, memOut, Mem2Reg);
    output [31:0] wb;
    input [31:0] exeOut, memOut;
    input Mem2Reg;
    // instantiate the circuit (only one line)
    yMux #(32) MR(wb,exeOut,memOut,Mem2Reg);
endmodule
module yEX (z, zero, rd1, rd2, imm, op, ALUSrc);
    output [31:0] z;
    output zero;
    input [31:0] rd1, rd2, imm;
    input [2:0] op;
    input ALUSrc;
    //Complete the development of yEX.
    wire [31:0] b;
    yMux #(32) my_Mux(b, rd2, imm, ALUsrc);
    yAlu my_Alu(z, zero, rd1, b, op);
endmodule
module yID(rd1, rd2, immOut, jTarget, branch, ins, wd, RegWrite, clk); 
    output [31:0] rd1, rd2, immOut, branch;
    output [31:0] jTarget;

    input [31:0] ins, wd;
    input RegWrite, clk;

    wire [19:0] zeros, ones; // For I-Type and SB-Type
    wire [11:0] zerosj, onesj; // For UJ-Type
    wire [31:0] imm, saveImm; // For S-Type

    rf myRF (rd1, rd2, ins[19:15], ins[24:20], ins[11:7], wd, clk, RegWrite);

    assign imm[11:0] = ins[31:20];
    assign zeros = 20'h00000;
    assign ones = 20'hFFFFF;
    yMux #(20) se(imm[31:12], zeros, ones, ins[31]);

    assign saveImm[11:5]= ins[31:25];
    assign saveImm[4:0] = ins[11:7];

    yMux #(20) save_ImmSe(saveImm[31:12], zeros, ones, ins[31]); 
    yMux #(32) immSelection(immOut, imm, saveImm, ins[5]);

    assign branch [11] = ins[31];
    assign branch [10] = ins[7];
    assign branch [9:4] = ins[30:25];
    assign branch [3:0] = ins[11:8];
    yMux #(20) bra (branch[31:12], zeros, ones, ins[31]);

    assign zerosj= 12'h000; 
    assign onesj = 12'hFFF;
    assign jTarget [19] = ins[31];
    assign jTarget [18:11] = ins[19:12];
    assign jTarget [10] = ins[20];
    assign jTarget [9:0] = ins[30:21];
    yMux #(12) jum(jTarget[31:20], zerosj, onesj, jTarget[19]);
endmodule
module yIF(ins, PC, PCp4, PCin, clk);
    output [31:0] ins, PC, PCp4; 
    input [31:0] PCin;
    input clk;

    wire zero;
    wire read, write, enable; 
    wire [31:0] a, memIn;
    wire [2:0] op;

    register #(32) pcReg(PC, PCin, clk, enable); 
    mem insMem(ins, PC, memIn, clk, read, write); 
    yAlu myAlu(PCp4, zero, a, PC, op);

    assign enable = 1'b1;
    assign a = 32'h0004;
    assign op = 3'b010;
    assign read= 1'b1;
    assign write= 1'b0;
endmodule
module yAdder1 (z, cout, a, b, cin);
    output z, cout;
    input a, b, cin;
    xor left_xor (tmp, a, b); 
    xor right_xor (z, cin, tmp); 
    and left_and (outL, a, b); 
    and right_and (outR, tmp, cin); 
    or my_or (cout, outR, outL);
endmodule
module yAdder (z, cout, a, b, cin);
    // outputs
    output [31:0] z; 
    output cout;
    // inputs
    input [31:0] a, b; 
    input cin;
    // interconnects
    wire [31:0] in, out;
    // yAdder1 is defined in yAdder1.v 
    yAdder1 mine[31:0] (z, out, a, b, in);
    assign in[0] = cin; 
    assign in[31:1] = out [30:0]; 
endmodule
module yAlu(z, zero, a, b, op);
    // op=000: z=a AND b, op=001: z=a|b, op=010: z=a+b, op=110: z=a-b
    input [31:0] a, b;
    input [2:0] op;
    output [31:0] z;
    output zero;
    wire [31:0] zAnd, zor, zArith, slt, cond2;
    wire temp, cout, z1;
    assign slt[31:1]=0;
    wire [15:0] z16;
    wire [7:0] z8;
    wire [3:0] z4;
    wire [1:0] z2;

    

    xnor(temp, a[31], b[31]); // if (a[31]==b[31]) temp = 1 and slt[0]=cond[31] else temp = 0 and slt[0]=a[31]
    yArith my_Arith(cond2, cout, a, b, temp);
    yMux1 my_Mux1(slt[0], a[31], cond2[31], temp);

    assign zAnd = a & b;
    assign zor = a | b;
    yArith my_Arith2(zArith, cout, a, b, op[2]);
    yMux4to1 #(32) my_Mux4(z, zAnd, zor, zArith, slt, op[1:0]);
    
    or or16[15:0] (z16, z[15:0], z[31:16]);
    or or8[7:0] (z8, z16[7:0], z16[15:8]);
    or or4[3:0] (z4, z8[3:0], z8[7:4]);
    or or2[1:0] (z2, z4[1:0], z4[3:2]);
    or or1(z1, z2[0], z2[1]);
    not (zero, z1);
endmodule
module yArith (z, cout, a, b, ctrl);
    // add if ctrl=0, subtract if ctrl=1
    output [31:0] z;
    output cout;
    input [31:0] a, b;
    input ctrl;
    wire [31:0] notB;
    wire [31:0] tmp;
    wire cin;
    integer i;
    // instantiate the components and connect them // Hint: about 4 lines of code
    assign notB = ~b;
    yMux #(32) uut(tmp, b, notB, ctrl);
    yAdder uut2(z, cout, a, tmp, cin);
    assign cin = ctrl;
endmodule
module yMux (z, a, b, c); 
    parameter SIZE = 2; //like java's final statement, but more powerful.
    output [SIZE-1:0] z;
    input [SIZE-1:0] a, b; 
    input c;
    yMux1 mine[SIZE-1:0](z, a, b, c);
endmodule
module yMux1 (z, a, b, c); 
    output z;
    input a, b, c;
    wire notC, upper, lower; 
    not my_not (notC, c);
    and upperAnd (upper, a, notC); 
    and lowerAnd (lower, c, b); 
    or my_or (z, upper, lower); 
endmodule
module yMux2 (z, a, b, c); 
    output [1:0] z;
    input [1:0] a, b; 
    input c;
    yMux1 upper(z[0], a[0], b[0], c); 
    yMux1 lower(z[1], a[1], b[1], c);
endmodule//four way multiplexer
module yMux4to1 (z, a0, a1, a2, a3, c); 
    parameter SIZE = 2;
    output [SIZE-1:0] z;
    input [SIZE-1:0] a0, a1, a2, a3; 
    input [1:0] c;
    wire [SIZE-1:0] zLo, zHi;
    yMux #(SIZE) lo(zLo, a0, a1, c[0]);
    yMux #(SIZE) hi(zHi, a2, a3, c[0]); 
    yMux #(SIZE) final(z, zLo, zHi, c[1]); 
endmodule