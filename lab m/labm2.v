
module labM; 
reg [31:0] d, e; 
reg clk, enable, flag, passed, start;
wire [31:0] z;
register #(32) mine(z, d, clk, enable);
initial
begin
    flag = $value$plusargs("enable=%b", enable);
    start = 0;
    passed = 1;
    $monitor("%5d: passed:%b clk=%b,d=%d,z=%d,expect=%d", $time, passed, clk, d, z, e); 
    clk = 0;
    repeat(20) begin
        #2;
        d = $random;
    end
$finish;
end

always begin
    #5; 
    clk = ~clk; //ocillation of the clk after every 5 units, forever.
end

always @(posedge clk) begin //when clk hits posedge change expectation to latest d.
    e = d;
    start = 1; //e got a value begin oracle
end   

//oracle
always begin  //check with every change in d.
    #2;
    if (start == 1) //begin after e gets a value.
        if (z==e)
            passed = 1;
        else
            passed = 0;
end
endmodule

/* tracing 0-18 units of time:
0-4: clk = 0, z is evaluated, d changes twice.
5: clk = 1, e updated to d @4.
6-8: @6 z==(d @4)?, d changes. @8 z==(d @4)?, d changes.
10: clk = 0, d changes, z==(d @4)?.
11-14: @12 z==(d @4)?, d changes. @14 z==(d @4)?, d changes.
15: clk = 1, e updated to d @14.
16-18: @16 d changes, z==(d @14)?. @18 d changes, z==(d @14)?.
*/