module UART_tb();

logic trmt, tx_done, clk, rst_n, rdy, clr_rdy, TX, RX;
logic [7:0] tx_data, rx_data;

UART_tx iTx (.trmt(trmt), .tx_data(tx_data), .tx_done(tx_done), .clk(clk), .rst_n(rst_n), .TX(TX));
UART_rx iRx (.RX(RX), .clk(clk), .rst_n(rst_n), .rdy(rdy), .rx_data(rx_data), .clr_rdy(clr_rdy));

always 
	#5 clk = ~clk;
	
initial begin
	clk = 0;
	rst_n = 0;
	trmt = 0;
	clr_rdy = 0;
	tx_data = 8'h55;
	
	@(negedge clk);
	rst_n = 1;
	trmt = 1;
	@(negedge clk);
	trmt = 0;
	
	repeat(28644) @(posedge clk);
	$stop();
end
endmodule