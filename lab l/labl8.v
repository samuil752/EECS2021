
//testing yArith.v
module tb_yArith;
    wire signed [31:0] z;
    reg signed [31:0] a, b, expect; 
    reg ctrl;
    wire cout;

    //function call
    yArith name(z, cout, a, b, ctrl);

    // The "Oracle" testing system
    initial
        begin
            repeat(10)
            begin
                a = $random;
                b = $random;
                ctrl = $random % 2;
                if (ctrl == 0)
                    expect = a + b;
                else
                    expect = a - b;
                #1 //wait for z with change of inputs propagation delay
                //oracle
                if (expect === z) $display("passed: a:%b b:%b ctrl:%b z:%b", a, b, ctrl, z);
                else $display("failed: a:%b b:%b ctrl:%b z:%b", a, b, ctrl, z);
            end
        $finish;
        end
endmodule