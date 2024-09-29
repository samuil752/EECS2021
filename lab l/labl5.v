//test for yAdder1.v
module tb_yAdder1;
    integer i, j, k;
    wire cout, z;
    reg a, b, cin;
    reg[0:1] expected;

    yAdder1 name(z, cout, a, b, cin);
    initial begin
        for (i =0; i<2; i=i+1)
        begin
            for (j=0; j<2; j=j+1)
            begin
                for (k=0; k<2; k=k+1)
                begin
                    a=i;
                    b=j;
                    cin=k;
                    expected = (a+b+cin);
                    #10 //wait for z and cout
                    if (expected[1]==z && expected[0]==cout)
                        $display("passed");
                    else
                        $display("failed");
                end
            end
        end
    $finish;
    end
endmodule