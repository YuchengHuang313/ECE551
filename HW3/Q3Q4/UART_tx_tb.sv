module UART_tx_tb();

logic clk, rst_n, TX, trmt, tx_done;
logic [7:0] tx_data;

UART_tx iDUT(.clk(clk), .rst_n(rst_n), .TX(TX), .trmt(trmt), .tx_data(tx_data), .tx_done(tx_done));

always
	#5 clk = ~clk;
	
initial begin
	clk = 0;
	rst_n = 0;
	trmt = 0;
	tx_data = 8'h55;
	
	@(negedge clk);
	rst_n = 1;
	trmt = 1;
	@(negedge clk);
	// trmt = 0;
	
	repeat(28644) @(posedge clk);
	$stop();
	
end 

endmodule
