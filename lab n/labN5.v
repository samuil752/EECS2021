
module labN;
reg [31:0] entryPoint;
reg  clk, INT;
wire [31:0] ins, rd2, wb;
yChip myCPUchip(ins, rd2, wb, entryPoint, INT, clk);
initial
begin
    //-----Entry point
    entryPoint = 32'h28; INT = 1; #1;
    //------Run program 
    repeat (43)
    begin
        //-----Fetch an ins
        clk =1; #1; //wait until instruction is fetched
        INT = 0;
        //-------execute the ins
        clk = 0;
        #1;
        //-------view results
        $display("%h: rd2:%2d wb:%2d", ins, rd2, wb);
    end
    $finish;
end
endmodule
