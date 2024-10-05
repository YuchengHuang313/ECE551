module Dterm_tb();

logic err_vld, rst_n, clk;
logic signed [9:0] err_sat;
logic signed [12:0] D_term;

Dterm iDUT(.err_sat(err_sat), .err_vld(err_vld), .rst_n(rst_n), .clk(clk), .D_term(D_term));

always
	#5 clk = ~clk; 



endmodule