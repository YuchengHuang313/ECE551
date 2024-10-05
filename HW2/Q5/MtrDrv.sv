module MtrDrv (
    input signed [10:0] lft_spd,
    input signed [10:0] rght_spd,
    input clk,
    input rst_n,
    output lftPWM1,
    output lftPWM2,
    output rghtPWM1,
    output rghtPWM2
);
  // lft_spd and rght_spd are signed 11 bit number that can go from max 11'h3ff
  // to min 11'h-400
  PWM11 lft_PWM11 (
      .duty(lft_spd + 11'h400),
      .clk(clk),
      .rst_n(rst_n),
      .PWM_sig(lftPWM1),
      .PWM_sig_n(lftPWM2)
  );
  PWM11 rght_PWM11 (
      .duty(rght_spd + 11'h400),
      .clk(clk),
      .rst_n(rst_n),
      .PWM_sig(rghtPWM1),
      .PWM_sig_n(rghtPWM2)
  );
endmodule
