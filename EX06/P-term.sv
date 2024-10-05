module P_term (input signed [11:0] error, output signed [13:0] P_term);

localparam P_COEFF = 6'h10;
logic signed [9:0] sat;

assign sat = (~error[11] & |error[10:9]) ? 10'h1ff :
		(error[11] & ~&error[10:9]) ? 10'h200 :
		error[9:0];

assign P_term = sat * P_COEFF;

endmodule