
module labL;
    reg signed [31:0] a, b; 
    reg [31:0] expect;
    reg [2:0] op;
    reg ok, flag, tmp, exWork;
    wire zero;
    wire [31:0] z;
    yAlu mine(z, zero, a, b, op);
    initial
    begin
        repeat (10)
        begin
            a = $random;
            b = $random;
            tmp = $random % 2;
            if (tmp==0) b=a; // this is for testing zero exception by using op code 110 **subtraction**.
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
            #10
            if (expect==z)
                ok = 1'b1;
            else
                ok = 1'b0;
            if ((z==0 && zero==1)||(z!=0 && zero==0))
                exWork = 1'b1;
            else
                exWork = 1'b0;
            // Display ok and the various signals 
            $display("ok?:%b, exception Worked?:%b, a:%b, b:%b, z:%b, expected:%b, zero:%b, op:%b", ok, exWork, a, b, z, expect, zero, op);    
        end
    $finish;
    end
endmodule