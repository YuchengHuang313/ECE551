module PWM11_tb ();

  logic clk, rst_n, PWM_sig, PWM_sig_n;
  logic [10:0] duty;

  PWM11 iDUT (
      .clk(clk),
      .rst_n(rst_n),
      .duty(duty),
      .PWM_sig(PWM_sig),
      .PWM_sig_n(PWM_sig_n)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    clk   = 0;
    rst_n = 0;
    duty  = 11'h000;

    // Test 0: test reset
    @(negedge clk);
    if ((PWM_sig == 0) && (PWM_sig_n == 1))
      $display("Test 0 passed: duty = 0, PWM_sig = 0, PWM_sig_n = 1");
    else $display("Test 0 failed: duty = 0, expected PWM_sig = 0, PWM_sig_n = 1");
    rst_n = 1;  // Deassert the reset

    // Test 1: duty = 0, expect PWM_sig to be 0, PWM_sig_n to be 1 (always low PWM signal)
    @(negedge clk);
    if ((PWM_sig == 0) && (PWM_sig_n == 1))
      $display("Test 1 passed: duty = 0, PWM_sig = 0, PWM_sig_n = 1");
    else $display("Test 1 failed: duty = 0, expected PWM_sig = 0, PWM_sig_n = 1");
    repeat (2047) @(negedge clk);

    // Test 2: duty = max (2047), expect PWM_sig to be 1, PWM_sig_n to be 0 (always high PWM signal)
    duty = 11'b11111111111;
    @(negedge clk);
    repeat (10) @(negedge clk);  // Wait for a few clock cycles
    if ((PWM_sig == 1) && (PWM_sig_n == 0))
      $display("Test 2 passed: duty = max, PWM_sig = 1, PWM_sig_n = 0");
    else $display("Test 2 failed: duty = max, expected PWM_sig = 1, PWM_sig_n = 0");
    repeat (2038) @(negedge clk);

    // Test 3&4: duty = 1024 (50%), expect PWM_sig to toggle at 50% duty cycle
    duty = 11'd1024;
    repeat (1023) @(negedge clk);  // test right before 50% duty reached
    if ((PWM_sig == 1) && (PWM_sig_n == 0))
      $display("Test 3 passed: duty = 50%%, PWM_sig = 1, PWM_sig_n = 0");
    else $display("Test 3 failed: duty = 50%%, expected PWM_sig = 1, PWM_sig_n = 0");
    @(negedge clk);  // test right after 50% duty reached
    if ((PWM_sig == 0) && (PWM_sig_n == 1))
      $display("Test 4 passed: duty = 50%%, PWM_sig = 0, PWM_sig_n = 1");
    else $display("Test 4 failed: duty = 50%%, expected PWM_sig = 0, PWM_sig_n = 1");



    repeat (1023) @(negedge clk);
    $stop();
  end

endmodule
