module UART_wrapper (input clr_cmd_rdy, input RX, input trmt, input [7:0] resp, input clk, input rst_n, 
						output logic cmd_rdy, output logic [15:0] cmd, output tx_done, output TX);

logic rx_rdy, clr_rx_rdy;
logic [7:0] rx_data;

UART uart(.rx_rdy(rx_rdy), .rx_data(rx_data), .clr_rx_rdy(clr_rx_rdy), .trmt(trmt), 
			.tx_data(resp), .tx_done(tx_done), .clk(clk), .rst_n(rst_n), .RX(RX), .TX(TX));

// FSM states
typedef enum logic {HIGH, LOW} state_t;
state_t state, nxt_state;

logic [7:0] high_byte;
logic byte_sel, set_cmd_rdy;

// dataflow within the wrapper
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		high_byte <= 8'h0;
	else if (byte_sel)
		high_byte <= rx_data;
assign cmd = {high_byte, rx_data};

// SR flop to keep the the cmd_rdy until next iteration
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		cmd_rdy <= 1'b0;
	else if (set_cmd_rdy)
		cmd_rdy <= 1'b1;
	else if (clr_cmd_rdy | byte_sel)
		cmd_rdy <= 1'b0;

// FSM flop
always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		state <= HIGH;
	else 
		state <= nxt_state;
		
// FSM logic
always_comb begin
    byte_sel = 1'b0; // Default to 0
    clr_rx_rdy = 1'b0;
    set_cmd_rdy = 1'b0;
    nxt_state = state;

    case(state)
        default: // Waiting for high byte reception
            if (rx_rdy) begin
                byte_sel = 1'b1; // Capture the high byte
                clr_rx_rdy = 1'b1;
                nxt_state = LOW;
            end

        LOW: // Waiting for low byte reception
            if (rx_rdy) begin
                set_cmd_rdy = 1'b1;
                clr_rx_rdy = 1'b1;
                nxt_state = HIGH;
            end
    endcase
end

endmodule		