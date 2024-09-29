
//test for yMux1.v
module tb_yMux1;
    wire z;
    reg a, b, c, expected;
    integer i, j, k;
    yMux1 asd(z, a, b, c);
    initial
        begin
            for (i=0;i<2;i=i+1)
                begin
                    for (j=0; j < 2; j=j + 1)
                        begin
                            for(k = 0; k < 2; k=k + 1)
                                begin
                                    a=i; b=j; c=k;
                                    expected = (a&~c)|(b&c);
                                    #10; //wait for z
                                    if (expected===z)
                                        $display("passed");
                                    else
                                        $display("failed");
                                end
                        end
                end
        $finish;
        end
endmodule