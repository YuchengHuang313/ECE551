module SDiv_tb ();

  logic clk, rst_n, go, rdy;
  logic [15:0] dividend, divisor, quotient;

  SDiv iDUT (
      .clk(clk),
      .rst_n(rst_n),
      .go(go),
      .rdy(rdy),
      .dividend(dividend),
      .divisor(divisor),
      .quotient(quotient)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst_n = 0;
    go = 0;
    dividend = -16'd12;
    divisor = 16'h0002;

    // negedge needed: 1 (after assert go) + dividend / divisor + 1 (if negative result) + 1 (output)
    // test 1: -12 / 2
    @(negedge clk);
    rst_n = 1;
    go = 1;
    @(negedge clk);
    go = 0;
    repeat (8) @(negedge clk);
    if (quotient !== -16'd6)
        $display("Test Case 1 failed: The output of %x / %x should be %x, but it is returning %x", dividend, divisor, -16'd6, quotient);
    else if (rdy !== 1)
        $display("Test Case 1 failed: rdy should be 1 but it is not");
    else 
        $display("Test Case 1 passed");

    // test 2: 8 / 22 
    @(negedge clk)
    dividend = 16'd8;
    divisor = 16'h2;
    go = 1;
    @(negedge clk)
    go = 0;

    repeat(6) @(negedge clk);
    if (quotient !== 16'd4)
        $display("Test Case 2 failed: The output of %x / %x should be %x, but it is returning %x", dividend, divisor, 16'd4, quotient);
    else if (rdy !== 1)
        $display("Test Case 2 failed: rdy should be 1 but it is not");
    else 
        $display("Test Case 2 passed");

    // Test Case 3: Maximum positive value / 1
    @(negedge clk);
    dividend = 16'h7FFF;  // Maximum positive 16-bit signed value
    divisor = 16'd1;
    go = 1;
    @(negedge clk);
    go = 0;
    repeat (32769) @(negedge clk);
    if (quotient !== 16'h7FFF)
        $display("Test Case 3 failed: %0d / %0d should be %0d, but got %0d", dividend, divisor, 16'h7FFF, quotient);
    else if (rdy !== 1)
        $display("Test Case 3 failed: rdy should be 1 but is not");
    else
        $display("Test Case 3 passed");

    // Test Case 4: Maximum negative value / 1
    @(negedge clk);
    dividend = 16'h8000;  // Minimum negative 16-bit signed value
    divisor = -16'd1;
    go = 1;
    @(negedge clk);
    go = 0;
    repeat (32769) @(negedge clk);
    if (quotient !== 16'h8000)
        $display("Test Case 4 failed: %0d / %0d should be %0d, but got %0d", dividend, divisor, 16'h8000, quotient);
    else if (rdy !== 1)
        $display("Test Case 4 failed: rdy should be 1 but is not");
    else
        $display("Test Case 4 passed");

    // Test Case 5: negative / negative
    @(negedge clk);
    dividend = -16'd24;
    divisor = -16'd6;
    go = 1;
    @(negedge clk);
    go = 0;
    repeat (6) @(negedge clk);
    if (quotient !== 16'd4)
        $display("Test Case 5 failed: %0d / %0d should be %0d, but got %0d", dividend, divisor, 16'd4, quotient);
    else if (rdy !== 1)
        $display("Test Case 5 failed: rdy should be 1 but is not");
    else
        $display("Test Case 5 passed");

    // Test Case 6: positive / negative
    @(negedge clk);
    dividend = 16'd24;
    divisor = -16'd6;
    go = 1;
    @(negedge clk);
    go = 0;
    repeat (7) @(negedge clk);
    if (quotient !== -16'd4)
        $display("Test Case 6 failed: %x / %x should be %x, but got %x", dividend, divisor, -16'd4, quotient);
    else if (rdy !== 1)
        $display("Test Case 6 failed: rdy should be 1 but is not");
    else
        $display("Test Case 6 passed");

    repeat(6) @(negedge clk);
    $stop();
  end
endmodule
