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

  // FSM signals
  state_t state, nxt_state;
  logic negate_res, init;

  // internal signals
  logic [15:0] divisor_data, dividor_data;
  logic [1:0] quot_sel;

  // divisor
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) divisor_data <= 16'h0000;
    else if (init)
      divisor_data <= ((divisor[15]) ? (~divisor + 1) : divisor);  // get the abs value of divisor

  // dividend and remainder
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) dividor_data <= 16'h0000;
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

  // state flop
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) state <= IDLE;
    else state <= nxt_state;

  always_comb begin
    // default outputs to avoid latches
    init = 1'b0;
    rdy = 1'b0;
    quot_sel = 2'b00;

    case (state)
      /* COMPUTE state: we are waiting for the MSB to become 1 to tell
			that we have finsihed dividing. If we have finished dividing, we 
			should go into the negate state, otherwise we should wait
			*/
      COMPUTE:
      if (~dividor_data[15]) begin
        quot_sel  = 2'b01;
        nxt_state = COMPUTE;
      end else if (dividor_data[15]) begin
        quot_sel  = 2'b11;
        nxt_state = NEGATE;
      end

      /* NEGATE state: we check if go is 0 and if negate_res is 1 or 0 to 
			see if we need to negate the result before we assert rdy. If we get 
			a 1 for go, we clear all the data and go back to COMPUTE state
			*/
      NEGATE:
      if (~go) begin
        if (negate_res & quotient[15]) begin
          quot_sel  = 2'b10;
          nxt_state = NEGATE;
        end else if (~negate_res) begin
          quot_sel = 2'b11;
        end
        rdy = 1'b1;
        nxt_state = NEGATE;
      end else if (go) begin
        init = 1'b1;
        quot_sel = 2'b00;
        nxt_state = COMPUTE;
      end

      // Use the IDEL state as the default state and unused state
      default:
      if (go) begin
        init = 1'b1;
        nxt_state = COMPUTE;
      end else nxt_state = IDLE;
    endcase
  end

endmodule