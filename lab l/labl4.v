//four way multiplexer test

module tb_yMux4to1; 
    wire [31:0] z;
    reg [31:0] a0, a1, a2, a3; 
    reg [1:0] c;
    yMux4to1 #(32) test(z, a0, a1, a2, a3, c);
    initial begin
        repeat (10)    
            begin
                a0 = $random;
                a3 = $random;
                a1 = $random;
                a2 = $random;
                c[1] = $random % 2;
                c[0] = $random % 2;
                #10 // wait for z
                if ((c===2'b00 && z===a0)||(c===2'b01 && z===a1)||(c===2'b10 && z===a2)||(c===2'b11 && z===a3))
                    $display("passed: a0:%d, a1:%d, a2:%d, a3:%d, c:%b, z:%d",a0, a1, a2, a3, c, z);
                else 
                    $display("failed: a0:%d, a1:%d, a2:%d, a3:%d, c:%b, z:%d",a0, a1, a2, a3, c, z);
            end
    $finish;
    end
endmodule