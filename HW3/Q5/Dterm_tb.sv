module Dterm_tb();

logic err_vld, rst_n, clk;
logic signed [9:0] err_sat;
logic signed [12:0] D_term;

Dterm iDUT(.err_sat(err_sat), .err_vld(err_vld), .rst_n(rst_n), .clk(clk), .D_term(D_term));

always
	#5 clk = ~clk; 

initial begin
	err_vld = 0;
	rst_n = 0;
	clk = 0;
	err_sat = 10'h00f;

	@(negedge clk);
	rst_n = 1;
	err_vld = 1;
	repeat(3) @(negedge clk); // wait for 3 cycles till data arrives 
	

	repeat(10) @(negedge clk);
	$stop(); 

end

endmodule