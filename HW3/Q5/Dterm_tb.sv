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

	// Test Case 1: check D_term value when err_sat did not change
	@(negedge clk);
	rst_n = 1;
	err_vld = 1;
	repeat(3) @(negedge clk); // wait for 3 cycles till data arrives 
	if (D_term == 13'd0)
		$display("err_sat did not change in the last 3 cycle, D_term should be 0, but it is %x", D_term);
	else 
		$display("Test Case 1 Passed");
		
	// Test Case 2: check proper D_term update after another cycle
	@(negedge clk);
	err_sat = 10'h00a;
	@(negedge clk);
	
	repeat(10) @(negedge clk);
	$stop(); 

end

endmodule