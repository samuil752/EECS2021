
module labL;
    reg signed [31:0] a, b; 
    reg [31:0] expect;
    reg [2:0] op;
    reg ok, flag;
    wire ex;
    wire [31:0] z;
    yAlu mine(z, ex, a, b, op);
    initial
    begin
        repeat (10)
        begin
            a = $random;
            b = $random;
            flag = $value$plusargs ("op=%d", op);
            // The oracle: compute "expect" based on "op" #1;
            if (op==3'b000)
                expect = a & b;
            else if (op==3'b001)
                expect = a | b;
            else if (op==3'b010)
                expect = a + b;
            else if (op==3'b110)
                expect = a - b;
            else if (op==3'b111)
                expect = (a < b)? 1:0;
            else
                expect = 0;
            // Compare the circuit's output with "expect" // and set "ok" accordingly
            #1
            if (expect==z)
                ok = 1'b1;
            else
                ok = 1'b0;
            // Display ok and the various signals 
            $display("ok?:%b, a:%b, b:%b, z:%b, expected:%b, ex:%b, op:%b", ok, a, b, z, expect, ex, op);    
        end
    $finish;
    end
endmodule