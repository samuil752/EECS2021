
`timescale 1 ns/10 ps
module dff_tb(); //testbench (only for simulation purposes)
    integer k; // for the loops
    parameter SIZE = 4; 
    reg [SIZE-1:0] din;
    reg clock=1'b1;
    reg rst_n=1'b1;     //initial deasserted.
    wire [SIZE-1:0] qout, qbout;
    defparam myDFF.SIZE = SIZE;
    dff myDFF (.clk (clock), .reset (rst_n), .d(din), .q(qout), .qb (qbout));
    initial begin
        $dumpfile ("dump.vcd"); //to capture signals for gtkwave waveform viewer 
        $dumpvars (1);
        #1 rst_n=1'b0;//assert low-active reset.
        #2 rst_n=1'b1;
        for (k=0; k<31; k=k+1) begin
            #2 din=$random ;
        end
        $finish;
    end
    always begin
        //to capture values, in the output file.
        #4
        $display ("Time: %3d (din, clock, qout, qbout }: %2d %1b %2d %1b", $time, $unsigned (din), clock, $unsigned (qout), qbout );
    end
    always begin
        #4 clock=~clock;
    end
endmodule


//--D Flip Flop
module dff (clk, reset, d, q, qb);
parameter SIZE = 1;
input   clk, reset;
input   [SIZE-1:0] d;
output reg  [SIZE-1:0] q;
output  [SIZE-1:0] qb; //wire type, by default
//--- Main Code
assign qb=~q;
always @(posedge clk or negedge reset) begin
    if (!reset) begin // Async, low active reset
        q <= 1'b0;
    end else begin 
        q <= d; // Sync to clk. Assign D to Q on positive clock edge
    end
end
endmodule

