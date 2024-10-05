module ff_tb;

  // Testbench signals
  reg d, clk, rst_h;
  wire q;

  // Instantiate the D flip-flop module (Device Under Test)
  ff_w_rst DUT (.d(d), .clk(clk), .rst_h(rst_h), .q(q));

  // Clock generation: Toggle clock every 5 time units
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initial values
    d = 0;
    rst_h = 0;  // Reset is inactive at the beginning

    // Apply reset
    #10;
    rst_h = 1;  // Assert reset
    #10;
    rst_h = 0;  // Deassert reset

    // Apply some test values to D
    #10;
    d = 1;  // Set D to 1
    #10;
    d = 0;  // Set D back to 0
    #10;
    d = 1;  // Set D to 1 again
    #10;

    // Assert reset in the middle of the operation
    rst_h = 1;
    #10;
    rst_h = 0;

    // Test more values
    d = 0;
    #10;
    d = 1;
    #10;

    // End simulation after 100 time units
    #100;
    $stop;
  end

  // Monitor the values of the signals
  initial begin
    $monitor("Time: %0t | D = %b, CLK = %b, RST_H = %b, Q = %b", $time, d, clk, rst_h, q);
  end

endmodule
