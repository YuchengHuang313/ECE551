module PWM11(input clk, input rst_n, input [10:0]duty, output logic PWM_sig, output logic PWM_sig_n);

logic [10:0] cnt;
logic duty_input;

// comb logic for checking cnt < duty
always_comb 
	if (cnt < duty) 
		duty_input = 1;
	else 
		duty_input = 0;

// flip flop for counting the duty cycle
always_ff @(posedge clk, negedge rst_n)
	if(!rst_n)
		cnt = 10'h000;
	else 
		cnt <= cnt + 1;

// flip flop for outputing pwm
always_ff @(posedge clk, negedge rst_n)
	if(!rst_n) begin
		PWM_sig = 0;
		PWM_sig_n = 1;
	end
	else begin
		PWM_sig <= duty_input;
		PWM_sig_n <= ~duty_input;
	end
endmodule