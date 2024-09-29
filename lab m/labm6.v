
module labM;
reg clk, read, write;
reg [31:0] address, memIn;
wire [31:0] memOut;

mem data(memOut, address, memIn, clk, read, write);
initial
begin
    address = 16'h28; write = 0; read = 1; 

    repeat (11) begin
        #1;
        //R-type: 0110011
        if (memOut[6:0] == 7'h33) begin
            $display("time:%1d memOut:%h %h %h %h", $time, memOut[24:20], memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]); address = address + 4;
        end
        //Similarly, you can detect the UJ-type as follows: 1101111
        if (memOut[6:0]== 7'h6F) begin
            $display("time:%1d memOut:%h %h %h", $time, memOut[31:12], memOut[11:7], memOut[6:0]); address = address + 4;
        end
        //For I-Type: 0000011
        if (memOut[6:0] == 7'h3 || memOut[6:0] == 7'h13) begin
            $display("time:%1d memOut:%h %h %h %h", $time, memOut[31:20], memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]); address = address + 4;
        end
        // For S-Type: 0100011
        if (memOut[6:0] == 7'h23) begin
             $display("time:%1d memOut:%h %h %h %h %h", $time, memOut[31:25], memOut[24:20], memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]); address = address + 4;
        end
        // And for SB-Type: 1100011
        if (memOut[6:0] == 7'h63) begin
            $display("time:%1d memOut:%h %h %h %h %h", $time, memOut[31:25], memOut[24:20], memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]); address = address + 4;
        end
    end
$finish;
end
endmodule