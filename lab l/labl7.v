
//testing yAdder2.v
module tb_yAdder;
    wire signed [31:0] z;
    reg signed [31:0] a, b, expect; 
    reg cin; 
    wire cout;

    //function call
    yAdder name(z, cout, a, b, cin);

    // The "Oracle" testing system
    initial
        begin
            repeat(10)
            begin
                a = $random;
                b = $random;
                cin = 0;
                expect = a + b + cin;
                #1 //wait for z with change of inputs propagation delay
                //oracle
                if (expect === z) $display("passed: a:%b b:%b c:%b z:%b", a, b, cin, z);
                else $display("failed: a:%b b:%b c:%b z:%b", a, b, cin, z);
            end
        $finish;
        end
endmodule