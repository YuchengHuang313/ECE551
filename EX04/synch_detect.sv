module synch_detect(input asynch_sig_in, input clk, output fall_edge);

logic ff1_to_ff2, ff2_to_ff3, ff3_to_output;
and and1(fall_edge, ~ff2_to_ff3, ff3_to_output);

dff ff1(.D(asynch_sig_in), .clk(clk), .Q(ff1_to_ff2)), ff2(.D(ff1_to_ff2), .clk(clk), .Q(ff2_to_ff3)), ff3(.D(ff2_to_ff3), .clk(clk), .Q(ff3_to_output));

endmodule