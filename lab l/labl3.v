//test for yMux.v
module tb_yMux; 
    wire [31:0] z;
    reg [31:0] a, b; 
    reg c;
    yMux #(32) name(z, a, b, c);
    initial begin
        repeat (10)
            begin
                a = $random;
                b = $random;
                c = $random % 2;
                #1
                if ((c===1 && z==b)||(c===0 && z===a))
                    $display("passed: z:%b", z);
                else 
                    $display("failed: z:%b", z);
                    
            end
    $finish;
    end
endmodule