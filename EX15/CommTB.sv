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
	
	
	
	repeat(60000) @(negedge clk);
	$stop();
end
endmodule