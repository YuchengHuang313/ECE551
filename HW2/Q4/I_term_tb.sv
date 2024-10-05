module I_term_tb ();

  logic clk, rst_n, err_vld, moving;
  logic signed [9:0] err_sat;
  logic signed [8:0] I_term;
  I_term iDUT (
      .clk(clk),
      .rst_n(rst_n),
      .moving(moving),
      .err_sat(err_sat),
      .I_term(I_term),
      .err_vld(err_vld)
  );

  initial begin
    clk = 0;
    rst_n = 0;
    moving = 1;
    err_vld = 1;
    err_sat = 10'h1ff;

    // Reset test
    @(posedge clk);
    if (I_term !== 10'h000) $display("I term should be 0 since we just reset it");
    else $display("I term is correct afer reset");

    // Deassert reset
    @(negedge clk);
    rst_n = 1;

    // test result after 10 cycles
    repeat (10) @(negedge clk);
    if (I_term !== (err_sat * 10) >> 6)
      $display("I term should be %h after 10 cycles, but it is %h", (err_sat * 10) >> 6, I_term);
    else $display("I term is correct afer 10 cycles");

    // test result after 31 cycles and reaches its maximum
    repeat (21) @(negedge clk);
    if (I_term !== (err_sat * 31) >> 6)
      $display("I term should be %h after 31 cycles, but it is %h", (err_sat * 31) >> 6, I_term);
    else $display("I term is correct afer 31 cycles");

    // test results after 31 cycles and overflow
    @(negedge clk);
    if ((I_term !== (err_sat * 32) >> 6))
      $display("I term should be %h after 32 cycles, but it is %h", (err_sat * 32) >> 6, I_term);
    else $display("I term is correct afer 32 cycles");

    repeat (10) @(negedge clk);
    if ((I_term !== (err_sat * 32) >> 6))
      $display("I term should be %h after 42 cycles, but it is %h", (err_sat * 42) >> 6, I_term);
    else $display("I term is correct afer 42 cycles");
    $stop();
  end

  always #5 clk = ~clk;

endmodule
