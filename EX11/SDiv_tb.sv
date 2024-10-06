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
    dividend = 16'h0008;
    divisor = 16'h0002;

    @(negedge clk);
    rst_n = 1;
    go = 1;
    @(negedge clk);
    go = 0;

    repeat (10) @(negedge clk);

    $stop();
  end
endmodule
