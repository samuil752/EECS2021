
module labM;
reg [31:0] PCin;
reg RegWrite, clk, ALUSrc;
reg [2:0] op;
wire [31:0] wd, rd1, rd2, imm, ins, PCp4, z, branch; 
wire [25:0] jTarget; 
wire zero;
yIF myIF (ins, PCp4, PCin, clk); //Inputs: PCin, clk. Outputs: ins, PCp4.
yID myID(rd1, rd2, imm, jTarget, branch, ins, wd, RegWrite, clk); //Inputs: ins, wd, RegWrite, clk. Outputs: rd1, rd2, imm, jTarget, branch.
yEX myEx (z, zero, rd1, rd2, imm, op, ALUSrc); //Inputs:  rd1, rd2, imm, op, ALUSrc. Outputs: z, zero.
assign wd = z;
initial
begin
    /*
    fetch(clk yes), decode(clk no), execute(clk no), writeback(clk yes).
    */
    //-----Entry point
    PCin = 16'h28;
    //------Run program 
    repeat (11)
    begin
        //------Set control signals 
        RegWrite = 0;
        //-----Fetch an ins
        clk =1; #1; //wait until instruction is fetched
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
        //Similarly, you can detect the UJ-type as follows: 1101111
        if (ins[6:0]== 7'h23) begin
            ALUSrc = 1;
            op = 3'b010; //sd
        end
        //For I-Type: 0000011
        if (ins[6:0] == 7'h3 || ins[6:0] == 7'h13) begin
            ALUSrc = 1;
            op = 3'b010; //lw, addi
        end
        //And for SB-Type: 1100011
        if (ins[6:0] == 7'h63) begin
            ALUSrc = 0;
            op = 3'b011; //branch
        end
        #5; //wait for z/wd and decode
        $display("ins:%h rd1:%h rd2:%h imm:%d jTarget:%h z:%h zero:%b", ins, rd1, rd2, imm, jTarget, z, zero);
        if (ins[6:0] == 7'h6F) begin
            PCin = jTarget; //unconditional jal
        end
        else
            if (ins[6:0] == 7'h63) begin
                if (z == 0) begin
                    PCin = branch;
                end
                else begin
                    PCin = PCp4;
                end
            end
            else begin
                RegWrite = 1; //write-back
                clk = 0; clk = 1;
                #1; //wait for write back
                PCin = PCp4;
            end
        clk = 0;
    end
$finish;
end 
endmodule
