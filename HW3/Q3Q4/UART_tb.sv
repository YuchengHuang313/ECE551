module UART_tb();

logic trmt, tx_done, clk, rst_n, rdy, clr_rdy, transmitted_data;
logic [7:0] tx_data, rx_data;

UART_tx iTx (.trmt(trmt), .tx_data(tx_data), .tx_done(tx_done), .clk(clk), .rst_n(rst_n), .TX(transmitted_data));
UART_rx iRx (.RX(transmitted_data), .clk(clk), .rst_n(rst_n), .rdy(rdy), .rx_data(rx_data), .clr_rdy(clr_rdy));

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

	// it takes 10 * 2604 cycles to transmit all data. 
    // but I am going to check whether it behaves properly in the next baud

    // Test Case 1: functionality test right after transmission finished
	repeat(26040) @(negedge clk); 
    if (tx_data != rx_data)
        $display("Tx data should be the same as Rx data, but they are: %x and %x respectively", tx_data, rx_data);
    else if (rdy != 1)
        $display("Since Tx data and Rx data are the same, rdy signal should be 1 but it is not");
    else if (tx_done != 0)
        $display("Tx_done supposes to be 0 immediately when rdy becomes 1 since transmission is not finished, but it is not");
    else  
        $display("Test Case 1 Passed");

    // Test Case 2: after another half baud, tx_done should be 1 since it has finished transmission data
    repeat(1302) @(negedge clk); 
    if (tx_done != 1)
        $display("Tx_done should be 1 by now, but it is not");
    else 
        $display("Test Case 2 Passed");

    // Test Case 3: check if clr_rdy works
    @(negedge clk)
    clr_rdy = 1;
    @(negedge clk)
    if (rdy != 0)
        $display("We just cleared clr_rdy but it is not 0 still");
    else  
        $display("Test Case 3 Passed");
    clr_rdy = 0; // deassert clr_rdy so we can transmit new data
    
    // Test Case 4: check another data transimission
    repeat(2000) @(negedge clk);
    tx_data = 8'haa;
    trmt = 1;
    @(negedge clk);
    trmt = 0;
    repeat(26040) @(negedge clk);
    if (tx_data != rx_data)
        $display("Tx data should be the same as Rx data, but they are: %x and %x respectively", tx_data, rx_data);
    else if (rdy != 1)
        $display("Since Tx data and Rx data are the same, rdy signal should be 1 but it is not");
    else if (tx_done != 0)
        $display("Tx_done supposes to be 0 immediately when rdy becomes 1 since transmission is not finished, but it is not");
    else  
        $display("Test Case 4 Passed");
    
    // Test Case 5: after another half baud, tx_done should be 1 since it has finished transmission data
    repeat(1302) @(negedge clk); 
    if (tx_done != 1)
        $display("Tx_done should be 1 by now, but it is not");
    else 
        $display("Test Case 5 Passed");

    // Test Case 6: check if clr_rdy works
    @(negedge clk)
    clr_rdy = 1;
    @(negedge clk)
    if (rdy != 0)
        $display("We just cleared clr_rdy but it is not 0 still");
    else  
        $display("Test Case 6 Passed");
	$stop();
end
endmodule