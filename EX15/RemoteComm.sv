module RemoteComm (input snd_cmd, clk, rst_n, RX, output logic cmd_snt, input [15:0] cmd, output TX);

typedef enum logic [1:0] {IDLE, HIGH, LOW} state_t;

state_t state, nxt_state;

logic [7:0] tx_data, rx_data, lower_cmd, higher_cmd;
logic trmt, rx_rdy, tx_done, sel_high, snd_cmd_ff1, snd_cmd_ff2, set_cmd_snt;

UART uart_tc (.tx_data(tx_data), .rx_data(rx_data), .trmt(trmt), .rx_rdy(rx_rdy), .clk(clk), .rst_n(rst_n),
				.TX(TX), .RX(RX), .tx_done(tx_done));

// Flop for selecting the tx data
always_ff @(posedge clk, posedge snd_cmd_ff2)
	if (snd_cmd_ff2)
		lower_cmd <= cmd[7:0];
assign higher_cmd = cmd[15:8];
assign tx_data = (sel_high) ? higher_cmd : lower_cmd;

// Double flop for snd_cmd
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n) begin
		snd_cmd_ff1 <= 1'b0;
		snd_cmd_ff2 <= 1'b0;
	end else begin
		snd_cmd_ff1 <= snd_cmd;
		snd_cmd_ff2 <= snd_cmd_ff1;
	end
	
// RS flop for cmd_snt
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		cmd_snt <= 1'b0;
	else if (snd_cmd_ff2)
		cmd_snt <= 1'b0;
	else if (set_cmd_snt)
		cmd_snt <= 1'b1;
		
// FSM flop
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		state <= IDLE;
	else 
		state <= nxt_state;
		
always_comb	begin
	sel_high = 1'b1;
	trmt = 1'b0;
	set_cmd_snt = 1'b0;
	nxt_state = state;
	
	case(state)
		default: // IDLE 
			if (snd_cmd) begin
				trmt = 1'b1;
				nxt_state = HIGH;
			end
			
		HIGH: 
			if (tx_done) begin
				trmt = 1'b1;
				sel_high = 1'b0;
				nxt_state = LOW;
			end
		
		LOW:
			if (tx_done) begin
				set_cmd_snt = 1'b1;
				nxt_state = IDLE;
			end else 
				sel_high = 1'b0;
	endcase	
end
endmodule