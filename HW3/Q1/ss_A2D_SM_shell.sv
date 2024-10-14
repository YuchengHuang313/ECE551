module ss_A2D_SM (
    clk,
    rst_n,
    strt_cnv,
    smp_eq_8,
    gt,
    clr_dac,
    inc_dac,
    clr_smp,
    inc_smp,
    accum,
    cnv_cmplt
);

  input clk, rst_n;  // clock and asynch reset
  input strt_cnv;  // asserted to kick off a conversion
  input smp_eq_8;  // from datapath, tells when we have 8 samples
  input gt;  // gt signal, has to be double flopped

  output logic clr_dac;  // clear the input counter to the DAC
  output logic inc_dac;  // increment the counter to the DAC
  output logic clr_smp;  // clear the sample counter
  output logic inc_smp;  // increment the sample counter
  output logic accum;  // asserted to make accumulator accumulate sample
  output logic cnv_cmplt;  // indicates when the conversion is complete

  /////////////////////////////////////////////////////////////////
  // You fill in the SM implementation. I want to see the use   //
  // of enumerated type for state, and proper SM coding style. //
  //////////////////////////////////////////////////////////////

  typedef enum logic [1:0] { // declare states
    IDLE,
    CNV,
    ACCUM
  } state_t;

  state_t state, nxt_state;
  logic gt_ff1, gt_ff2;
  // Double flop gt
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n | clr_dac) begin
      gt_ff1 <= 1'b0;
      gt_ff2 <= 1'b0;
    end else begin
      gt_ff1 <= gt;
      gt_ff2 <= gt_ff1;
    end

  always_ff @(posedge clk, negedge rst_n) // declare FSM flop
    if (!rst_n) state <= IDLE;
    else state <= nxt_state;

  always_comb begin // default outputs and nxt_state
    clr_dac = 0;
    inc_dac = 0;
    clr_smp = 0;
    inc_smp = 0;
    accum = 0;
    cnv_cmplt = 0;
    nxt_state = state;
	
    case(state)
      default: // IDEL state
        if (strt_cnv) begin
          clr_dac = 1;
          clr_smp = 1;
          nxt_state = CNV;
        end

      CNV: // if greater, go to accum state, otherwise keep inc
        if (~gt_ff2) begin
          inc_dac = 1;
        end else begin
          accum = 1;
          nxt_state = ACCUM;
        end

      ACCUM: // if we havent got all samples, go back to cnv, otherwise we have finished and go to IDLE
        if (~smp_eq_8) begin
          clr_dac = 1;
          inc_smp = 1;
          nxt_state = CNV;
        end else begin
          cnv_cmplt = 1;
          nxt_state = IDLE;
        end
    endcase

  end
endmodule

