module Shifter_tb ();

  logic signed [15:0] src;
  logic arith;
  logic [3:0] amt;
  logic signed [15:0] res;

  Shifter iDUT (
      .src  (src),
      .arith(arith),
      .amt  (amt),
      .res  (res)
  );

  initial begin
    // Test Case 1: Logical right shift
    src   = 16'h1234;
    amt   = 4'b0001;
    arith = 0;
    #10;
    if (res != 16'h091A)  // Expected result is a 1-bit right shift with zero fill
      $display("Test failed: expected 16'h091A, got %h", res);
    else $display("Test 1 passed!");

    // Test Case 2: Arithmetic right shift with negative number
    src   = 16'hF000;  // -4096 in signed 16-bit
    amt   = 4'b0010;  // Shift by 2
    arith = 1;
    #10;
    if (res != 16'hFC00)  // Expected result is a sign-extended right shift (11111100_00000000)
      $display("Test failed: expected 16'hFC00, got %h", res);
    else $display("Test 2 passed!");

    // Test Case 3: Logical right shift by maximum amount (15 bits)
    src   = 16'h8001;
    amt   = 4'b1111;  // Shift by 15
    arith = 0;
    #10;
    if (res != 16'h0001)  // Logical shift will zero out all bits
      $display("Test failed: expected 16'h0001, got %h", res);
    else $display("Test 3 passed!");

    // Test Case 4: Arithmetic right shift by maximum amount (15 bits)
    src   = 16'h8001;  // MSB is 1 (negative number)
    amt   = 4'b1111;  // Shift by 15
    arith = 1;
    #10;
    if (res != 16'hFFFF)  // Sign-extended to -1 (all bits 1)
      $display("Test failed: expected 16'hFFFF, got %h", res);
    else $display("Test 4 passed!");

    // Test Case 5: Zero input, logical right shift
    src   = 16'h0000;
    amt   = 4'b0100;  // Shift by 4
    arith = 0;
    #10;
    if (res != 16'h0000)  // Shifting zero should still yield zero
      $display("Test failed: expected 16'h0000, got %h", res);
    else $display("Test 5 passed!");

    // Test Case 6: No shift (amt = 0)
    src   = 16'h5678;
    amt   = 4'b0000;  // No shift
    arith = 0;
    #10;
    if (res != 16'h5678)  // The result should be the same as the input
      $display("Test failed: expected 16'h5678, got %h", res);
    else $display("Test 6 passed!");

    // Test Case 7: Maximum positive signed value, arithmetic right shift
    src   = 16'h7FFF;  // +32767 in signed 16-bit
    amt   = 4'b0011;  // Shift by 3
    arith = 1;
    #10;
    if (res != 16'h0FFF)  // Expected result after a 3-bit arithmetic shift
      $display("Test failed: expected 16'h0FFF, got %h", res);
    else $display("Test 7 passed!");

    // Test Case 8: Negative signed value, arithmetic right shift
    src   = 16'h8000;  // -32768 in signed 16-bit
    amt   = 4'b0001;  // Shift by 1
    arith = 1;
    #10;
    if (res != 16'hC000)  // Expected result with sign extension (11000000_00000000)
      $display("Test failed: expected 16'hC000, got %h", res);
    else $display("Test 8 passed!");


    $stop();
  end

endmodule
