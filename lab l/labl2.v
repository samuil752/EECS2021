
module tb_yMux2;
    wire [1:0] z;
    reg [1:0] a, b;
    reg c;
    integer i, j, k;
    yMux2 asd(z, a, b, c);
    initial
        begin
            for (i=0;i<4;i=i+1)
                begin
                    for (j=0; j < 4; j=j + 1)
                        begin
                            for(k = 0; k < 2; k=k + 1)
                                begin
                                    a=i; b=j; c=k;
                                    #10; //wait for z
                                    if ((c===1 && z==b)||(c===0 && z===a))
                                        $display("passed");
                                    else 
                                        $display("failed");
                                end
                        end
                end
        $finish;
        end
endmodule