module UART_rx(input clk, input rst_n, input RX, input clr_rdy, output logic [7:0] rx_data, output logic rdy);

typedef enum logic {IDLE, CNT} state_t;
state_t state, nxt_state;
logic [8:0] rx_shft_reg;
logic [11:0] baud_cnt;
logic [3:0] bit_cnt;
logic shift, start, receiving, set_rdy, RX_flopped_1, RX_flopped_2;

// shifter data and rx_data output
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		rx_shft_reg <= 9'h1ff;
	else if (shift)
		rx_shft_reg <= {RX_flopped_2, rx_shft_reg[8:1]};
		
assign rx_data = rx_shft_reg[7:0];

// baud counter and shift signal
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		baud_cnt <= 12'hfff;
	else if (start)
		baud_cnt <= 12'd1302;
	else if (shift)
		baud_cnt <= 12'd2604;
	else if (receiving)
		baud_cnt <= baud_cnt - 1;

assign shift = (baud_cnt == 12'd0);

// bit counter
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		bit_cnt <= 4'h0;
	else if (start)
		bit_cnt <= 4'h0;
	else if (shift)
		bit_cnt <= bit_cnt + 1;
	
// RS flop
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		rdy <= 1'b0;
	else if (start | clr_rdy)
		rdy <= 1'b0;
	else if (set_rdy)
		rdy <= 1'b1;

// RX double flop
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n) begin 
		RX_flopped_1 <= 1'b1;
		RX_flopped_2 <= 1'b1;
	end else begin
		RX_flopped_1 <= RX;
		RX_flopped_2 <= RX_flopped_1;
	end
	
// FSM flop
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		state <= IDLE;
	else 
		state <= nxt_state;
		
// FSM
always_comb begin
	// set the default outputs
	start = 1'b0;
	receiving = 1'b0;
	set_rdy = 1'b0;
	nxt_state = state;
	
		case(state)
			CNT: // wait till all 9 bit data has transferred
				if (bit_cnt != 4'd10) begin
					receiving = 1'b1;
                end else begin
					set_rdy = 1'b1;
					nxt_state = IDLE;
                end
			default: // IDLE state
				if (~RX_flopped_2) begin
					start = 1'b1;
					nxt_state = CNT;
				end
		endcase
end
endmodule