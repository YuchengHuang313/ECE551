module PWM11_tb();

logic clk, rst_n, PWM_sig, PWM_sig_n;
logic [10:0] duty;

PWM11 iDUT(.clk(clk), .rst_n(rst_n), .duty(duty), .PWM_sig(PWM_sig), .PWM_sig_n(PWM_sig_n));

initial begin
	clk = 0;
	rst_n = 0;
	duty = 10'h000;
	
	@(posedge clk);
	@(negedge clk);
	rst_n = 1;		// deassert the rest
	
	@(posedge clk)
	if ((PWM_sig == 0) && (PWM_sig_n == 1))
		$display("PWM_sig is 0 and PWM_sig_n is 1 as expected");
	else
		$display("PWM_sig should always be 0 and PWM_sig_n should always be 1 since duty cycle is 0");

	repeat(10) @(posedge clk);
	$finish();
end
		
always
	#5 clk = ~clk;
endmodule