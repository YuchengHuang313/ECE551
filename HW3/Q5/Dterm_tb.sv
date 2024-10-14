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
	if (D_term !== 13'd0)
		$display("err_sat did not change in the last 3 cycle, D_term should be 0, but it is %x", D_term);
	else 
		$display("Test Case 1 Passed");
		
	// Test Case 2: check proper D_term update after another cycle
	@(negedge clk);
	err_sat = 10'h00a;
	@(negedge clk);
	if (D_term !== 13'h1fdd)
		$display("D_term should be 1fdd but it is %h", D_term);
	else 
		$display("Test Case 2 Passed");
		
	// Test Case 3: check if D_term goes back to 0 after 3 cycles
	repeat(3) @(negedge clk);
	if (D_term !== 13'd0)
		$display("err_sat did not change in the last 3 cycle, D_term should be 0, but it is %x", D_term);
	else 
		$display("Test Case 3 Passed");
	
	// Test Case 4: check if err_vld works
	@(negedge clk);
	err_vld = 0;
	err_sat = 10'h00b;
	repeat(10) @(negedge clk); // D_term should be constant over this period
	if (D_term !== 13'h007)
		$display("D_term should be %x but it is %x", 13'h007, D_term);
	else 
		$display("Test Case 4 passed");
	
	// Test Case 5: after releasing err_vld, next cycle should calculate based on data before err_vld = 1;
	@(negedge clk);
	err_vld = 1;
	err_sat = 10'h00c;
	@(negedge clk);
	if (D_term !== 13'h00e)
		$display("D_term should be 13'h00e, but it is %x", D_term);
	else 
		$display("Test Case 5 passed");
		
	
		
	repeat(10) @(negedge clk);
	$stop(); 

end

endmodule