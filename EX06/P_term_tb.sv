module P_term_tb();

logic [11:0] error;
logic [13:0] P_term;

P_term iDUT(.error(error), .P_term(P_term));

initial begin

	error = 12'h1ff;
	#10;
	error = 12'he00;
	#10;
	error = 12'h0ff;
	#10;
	error = 12'h8ff;
end

endmodule