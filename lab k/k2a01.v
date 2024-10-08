module labK;
    reg a,b;
    wire notOutput, lowerInput, tmp, z;
    // tmp is an output; b is an input
    not my_not (notOutput, b);
    //z output; a, tmp are inputs
    and my_and (z, a, lowerInput);
    assign lowerInput = notOutput;
    initial
    begin
        a = 1; b = 1;
        $display ("a=%b b=%b z=%b", a, b, z);
        $finish;
    end
endmodule