module I_term_tb();

logic clk, rst_n, err_vld, moving; 
logic signed [9:0] err_sat; 
logic signed [8:0] I_term;
I_term iDUT(.clk(clk), .rst_n(rst_n), .moving(moving), .err_sat(err_sat), .I_term(I_term), .err_vld(err_vld));

initial begin
	clk = 0;
	rst_n = 0;
	moving = 1;
	err_vld = 1;
	err_sat = 10'h1ff;
	@(posedge clk);
	if (I_term !== 10'h000) 
		$display("I term should be 0 since we just reset it");
	else 
		$display("I term is correct afer reset");

        @(negedge clk);
        rst_n = 1;

        repeat(10) @(negedge clk);
	if (I_term !== ((15'h01ff)*10)>>6) 
		$display("I term should be 0f4 after 10 cycles, but it is %h", I_term);
	else 
		$display("I term is correct afer 10 cycles");

	repeat (23) @(posedge clk);

	


	$stop();
end

always
	#5 clk = ~ clk;

endmodule