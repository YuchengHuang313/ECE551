module SDiv (
    clk,
    rst_n,
    go,
    dividend,
    divisor,
    quotient,
    rdy
);

  input clk, rst_n;
  input go;
  input [15:0] dividend;  // the numerator
  input [15:0] divisor;  // the denominator
  output reg [15:0] quotient;  // the whole # part of the answer
  output reg rdy;  // goes high and stays high when divide is done until next "go"

  ////////////////////////////////////////
  // declare state types as enumerated //
  //////////////////////////////////////
  typedef enum reg [1:0] {
    IDLE,
    COMPUTE,
    NEGATE
  } state_t;

  logic [14:0] divisor_data, dividor_data;
  logic negate_res, init;
  logic [1:0] quot_sel;

  // divisor
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) divisor_data <= 15'h0000;
    else if (init)
      divisor_data <= ((divisor[15]) ? (~divisor + 1) : divisor);  // get the abs value of divisor

  // dividend and remainder
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) dividor_data <= 15'h0000;
    else if (init)
      dividor_data <= ((dividend[15]) ? (~dividend + 1) : dividend) - divisor_data; // include alu for calc
    else if (!init) dividor_data <= dividor_data - divisor_data;  // including alu for calc

  // sign checker
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) negate_res <= 1'b0;
    else if (init) negate_res <= dividend[15] ^ divisor[15];

  // quotient 
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) quotient <= 16'h0000;
    else if (quot_sel == 2'b00) quotient <= 16'h0000;
    else if (quot_sel == 2'b01) quotient <= quotient + 1;
    else if (quot_sel == 2'b10) quotient <= ~quotient + 1;
endmodule






