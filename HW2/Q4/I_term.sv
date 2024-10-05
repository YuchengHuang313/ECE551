module I_term (
    input clk,
    input rst_n,
    input err_vld,
    input moving,
    input signed [9:0] err_sat,
    output signed [8:0] I_term
);

  logic signed [14:0] sign_ext_err_sat;
  logic signed [14:0] nxt_integrator;
  logic signed [14:0] integrator;
  logic input_sign_bit, integrator_sign_bit, overflow;
  wire signed  [14:0] mux1out;
  logic signed [14:0] accum_result;

  assign sign_ext_err_sat = {{5{err_sat[9]}}, err_sat[9:0]};

  assign input_sign_bit = sign_ext_err_sat[14];
  assign integrator_sign_bit = integrator[14];
  assign accum_result = (integrator + sign_ext_err_sat);
  assign overflow = (input_sign_bit == integrator_sign_bit) && (accum_result[14] != input_sign_bit);

  assign mux1out = (!overflow && err_vld) ? accum_result : integrator;
  assign nxt_integrator = moving ? mux1out : 15'h0000;

  always_ff @(posedge clk, negedge rst_n)
    // use nonblock to have the result set after the rising edge with
    // data right before the rising edge
    if (!rst_n)
      integrator <= 15'h0000;
    else integrator <= nxt_integrator;

  assign I_term = integrator[14:6];



endmodule
