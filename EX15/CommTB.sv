module CommTB();

logic [15:0] cmd_in, cmd_out;
logic snd_cmd, cmd_snt, clk, rst_n, TX_RX, cmd_rdy, clr_cmd_rdy;

RemoteComm rc (.cmd(cmd_in), .snd_cmd(snd_cmd), .cmd_snt(cmd_snt), .TX(TX_RX), .clk(clk), .rst_n(rst_n));
UART_wrapper wrp (.RX(TX_RX), .clk(clk), .rst_n(rst_n), .cmd(cmd_out), .cmd_rdy(cmd_rdy), .clr_cmd_rdy(clr_cmd_rdy));

always
	#5 clk = ~clk;
	
initial begin
	clk = 1'b0;
	rst_n = 1'b0;
	cmd_in = 16'hf00f;
	snd_cmd = 1'b0;
	clr_cmd_rdy = 1'b0;
	@(negedge clk);
	rst_n = 1'b1;
	snd_cmd = 1'b1;
	@(negedge clk);
	snd_cmd = 1'b0;
	
	// Test Case 1: normal data transfer
	// Since cmd_rdy happens at posedge clk, we wait half clk cycle to 
	// make sure data stability
	@(posedge cmd_rdy);
	@(negedge clk);
	if (cmd_out !== cmd_in)
		$display("cmd_out (%x) should be the same as cmd_in (%x) but it is not", cmd_out, cmd_in);
	else 
		$display("Test Case 1 Passed");
		
		
		
	// Test Case 2: another normal data transfer
	// cmd_snt would happen in a posedge clk, we need to wait for half clk cycle 
	// to make sure that snd_cmd can be received properly
	@(posedge cmd_snt);
	@(negedge clk);
	cmd_in = 16'h0ff0;
	snd_cmd = 1'b1;
	clr_cmd_rdy = 1'b1;
	@(negedge clk);
	snd_cmd = 1'b0;
	clr_cmd_rdy = 1'b0;
	@(posedge cmd_rdy);
	@(negedge clk); // wait for cmd_out to be stable
	if (cmd_out !== cmd_in)
		$display("cmd_out (%x) should be the same as cmd_in (%x) but it is not", cmd_out, cmd_in);
	else 
		$display("Test Case 2 Passed");
	
	repeat(120000) @(negedge clk);
	$stop();
end
endmodule