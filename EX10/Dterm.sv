module Dterm(input signed [9:0] err_sat, input err_vld, input rst_n, input clk, output logic signed [12:0] D_term);

localparam signed [4:0] D_COEFF = 5'h07;

logic signed [9:0] d1;
logic signed [9:0] d2;
logic signed [9:0] d3;
logic signed [9:0] q1;
logic signed [9:0] q2;
logic signed [9:0] prev_err;
logic signed [9:0] D_diff;
logic signed [7:0] sat_8;

always_ff @(posedge clk, negedge rst_n)
	if (!rst_n) begin
		q1 <= 10'h000;
		q2 <= 10'h000;
		prev_err <= 10'h000;
	end else if (err_vld) begin
		d1 <= q1;
		d2 <= q2;
		d3 <= prev_err;
	end

assign D_diff = err_sat - prev_err;
assign sat_8 = (~D_diff[9] & |D_diff[8:7]) ? 8'h7f 
		: (D_diff[9] & ~&D_diff[8:7]) ? 8'h80 
		: D_diff[7:0];

assign D_term = sat_8 * D_COEFF; 

endmodule 