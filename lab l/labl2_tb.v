

module tb_yMux2;

    // Declare inputs as reg and outputs as wire
    reg [1:0] a, b;
    reg c;
    wire [1:0] z;

    // Instantiate the yMux2 module
    yMux2 uut (
        .z(z),
        .a(a),
        .b(b),
        .c(c)
    );

    // Test procedure
    initial begin
        // Display header
        $display("Time\t a\t b\t c\t z");
        $monitor("%g\t %b\t %b\t %b\t %b", $time, a, b, c, z);
        
        // Apply test vectors
        // Test case 1
        a = 2'b00; b = 2'b00; c = 0; 
        #10; // Wait for 10 time units
        
        // Test case 2
        a = 2'b01; b = 2'b10; c = 0; 
        #10; // Wait for 10 time units
        
        // Test case 3
        a = 2'b01; b = 2'b10; c = 1; 
        #10; // Wait for 10 time units
        
        // Test case 4
        a = 2'b11; b = 2'b00; c = 0; 
        #10; // Wait for 10 time units
        
        // Test case 5
        a = 2'b11; b = 2'b00; c = 1; 
        #10; // Wait for 10 time units
        
        // Test case 6
        a = 2'b01; b = 2'b11; c = 1; 
        #10; // Wait for 10 time units
        
        // Test case 7
        a = 2'b10; b = 2'b01; c = 0; 
        #10; // Wait for 10 time units

        // Test case 8
        a = 2'b10; b = 2'b01; c = 1; 
        #10; // Wait for 10 time units
        
        // End simulation
        $finish;
    end

endmodule
