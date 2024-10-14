module Dterm(input signed [9:0] err_sat, input err_vld, input rst_n, input clk, output logic signed [12:0] D_term);

localparam signed [4:0] D_COEFF = 5'h07;

logic signed [9:0] ff1;
logic signed [9:0] ff2;
logic signed [9:0] prev_err;
logic signed [9:0] D_diff;
logic signed [7:0] sat_8;

always_ff @(posedge clk, negedge rst_n)
	if (!rst_n) begin
		ff1 <= 10'h000;
		ff2 <= 10'h000;
		prev_err <= 10'h000;
	end else if (err_vld) begin
		ff1 <= err_sat;
		ff2 <= ff1;
		prev_err <= ff2;
	end

assign D_diff = err_sat - prev_err;
assign sat_8 = (~D_diff[9] & |D_diff[8:7]) ? 8'h7f 
		: (D_diff[9] & ~&D_diff[8:7]) ? 8'h80 
		: D_diff[7:0];

assign D_term = sat_8 * D_COEFF; 

endmodule 