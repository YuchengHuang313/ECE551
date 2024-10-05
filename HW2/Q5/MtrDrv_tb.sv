module MtrDrv_tb ();

  logic signed [10:0] lft_spd;
  logic signed [10:0] rght_spd;
  logic lftPWM1, lftPWM2, rghtPWM1, rghtPWM2, clk, rst_n;

  MtrDrv iDUT (
      .lft_spd(lft_spd),
      .rght_spd(rght_spd),
      .clk(clk),
      .rst_n(rst_n),
      .lftPWM1(lftPWM1),
      .lftPWM2(lftPWM2),
      .rghtPWM1(rghtPWM1),
      .rghtPWM2(rghtPWM2)
  );


  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst_n = 0;

    // Test 1: Full forward speed for left, full reverse speed for right
    lft_spd = 11'h3ff;
    rght_spd = -11'h400;
    @(negedge clk);
    rst_n = 1;  // Deassert rst_n, pwm begins
    @(negedge clk);
    if (lftPWM1 != 1 || lftPWM2 != 0)
      $display(
          "Test 1 failed: lftPWM1 should be 1 and lftPWM2 should be 0, but they are %b and %b",
          lftPWM1,
          lftPWM2
      );
    else if (rghtPWM1 != 0 || rghtPWM2 != 1)
      $display(
          "Test 1 failed: rghtPWM1 should be 0 and rghtPWM2 should be 1, but they are %b and %b",
          rghtPWM1,
          rghtPWM2
      );
    else $display("Test 1 passed");
    repeat (2047) @(negedge clk);  // consume all remaining period

    // Test 2: Full reverse speed for left, full forward speed for right
    lft_spd  = -11'h400;
    rght_spd = 11'h3ff;
    @(negedge clk);
    if (lftPWM1 != 0 || lftPWM2 != 1)
      $display(
          "Test 2 failed: lftPWM1 should be 0 and lftPWM2 should be 1, but they are %b and %b",
          lftPWM1,
          lftPWM2
      );
    else if (rghtPWM1 != 1 || rghtPWM2 != 0)
      $display(
          "Test 2 failed: rghtPWM1 should be 1 and rghtPWM2 should be 0, but they are %b and %b",
          rghtPWM1,
          rghtPWM2
      );
    else $display("Test 2 passed");
    repeat (2047) @(negedge clk);

    // Test 3: Both motors at zero speed (neutral)
    lft_spd  = 11'h000;
    rght_spd = 11'h000;
    @(negedge clk);  // 50% duty cycle means 50% high 50% low
    if (lftPWM1 != 1 || lftPWM2 != 0)
      $display(
          "Test 3 failed: lftPWM1 and lftPWM2 should be 1 and 0, but they are %b and %b",
          lftPWM1,
          lftPWM2
      );
    else if (rghtPWM1 != 1 || rghtPWM2 != 0)
      $display(
          "Test 3 failed: rghtPWM1 and rghtPWM2 should 1 and 0, but they are %b and %b",
          rghtPWM1,
          rghtPWM2
      );
    else $display("Test 3 passed");
    // Test 4: half way in the 50% duty
    repeat (1024) @(negedge clk);  // jump to half way
    if (lftPWM1 != 0 || lftPWM2 != 1)
      $display(
          "Test 4 failed: lftPWM1 and lftPWM2 should 0 and 1, but they are %b and %b",
          lftPWM1,
          lftPWM2
      );
    else if (rghtPWM1 != 0 || rghtPWM2 != 1)
      $display(
          "Test 4 failed: rghtPWM1 and rghtPWM2 should 1 and 0, but they are %b and %b",
          rghtPWM1,
          rghtPWM2
      );
    else $display("Test 4 passed");
    repeat (1023) @(negedge clk);

    $stop();
  end
endmodule
