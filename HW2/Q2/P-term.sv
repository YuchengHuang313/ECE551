module P_term (
    input  signed [11:0] error,
    output signed [13:0] P_term
);

  localparam P_COEFF = 6'h10;
  logic signed [9:0] sat;

  assign sat = (~error[11] & |error[10:9]) ? 10'h1ff  // check if too positive
      : (error[11] & ~&error[10:9]) ? 10'h200  // check if too negative
      : error[9:0];  // input error is within the range

  assign P_term = sat * P_COEFF;

endmodule
