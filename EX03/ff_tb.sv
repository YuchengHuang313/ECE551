
module ff_tb();

	logic d, clk, rst_h, q;

	ff ff_DUT(.d(d), .rst_h(rst_h), .clk(clk), .q(q));
	initial begin:
		d = 0;
		clk = 0;
		rst_h = 0;
		#30;
		rst_h = 1;
		#30;
		$stop();
	
	end
	always @(posedge clk)
		#5 clk = ~clk;
endmodule;